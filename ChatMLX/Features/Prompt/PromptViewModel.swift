//
//  PromptViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import MarkdownUI
import Metal
import MLX
import MLXLLM
import MLXRandom
import SwiftUI
import Tokenizers

@Observable
class PromptViewModel {
    var text: String = ""
    var output: String = ""
    var selectedDisplayStyle: DisplayStyle = .markdown

    var selectedModel: String = "mlx-community/Qwen1.5-0.5B-4bit"

    var isPresentedParameters: Bool = false
    var temperature: Float = 0.6
    var topP: Float = 0.9
    var maxTokens: Int = 256
    var repetitionPenalty: Float = 1.0
    var repetitionContextSize: Int = 20

    let displayEveryNTokens = 4

    var running: Bool = false
    var stopping: Bool = false

    var loadState = ModelState.idle

    var showToast: Bool = false
    var toastTitle: String = ""

    var showErrorToast: Bool = false
    var error: String = ""

    var tokensPerSecond: Double = 0

    func openPromptParameters() {
        isPresentedParameters = true
    }

    func switchModel(model: String) {
        if selectedModel != model {
            selectedModel = model
            loadState = .idle
        }
    }

    func clear() {
        text = ""
    }

    func loadModel() async throws -> (LLMModel, Tokenizers.Tokenizer) {
        switch loadState {
        case .idle:
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let (llmModel, tokenizer) = try await load(modelName: selectedModel) {
                [selectedModel] progress in
                print("Downloading \(selectedModel): \(Int(progress.fractionCompleted * 100))%")
            }

            loadState = .loaded(selectedModel, llmModel, tokenizer)
            return (llmModel, tokenizer)

        case .loaded(let model, let llmModel, let tokenizer):
            if model != selectedModel {
                loadState = .idle
                return try await loadModel()
            }
            return (llmModel, tokenizer)
        }
    }

    func stop() {
        stopping = true
    }

    func run() async {
        let canRun = await MainActor.run {
            if running {
                return false
            } else {
                running = true
                output = ""
                self.tokensPerSecond = 0
                return true
            }
        }
        
        guard canRun else { return }

        do {
            let (model, tokenizer) = try await loadModel()

            let promptTokens = tokenizer.encode(text: text)

            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = await MLXLLM.generate(
                promptTokens: promptTokens,
                parameters: GenerateParameters(
                    temperature: temperature,
                    topP: topP,
                    repetitionPenalty: repetitionPenalty,
                    repetitionContextSize: repetitionContextSize
                ),
                model: model,
                tokenizer: tokenizer
            ) { tokens in
                if tokens.count % displayEveryNTokens == 0 {
                    let text = tokenizer.decode(tokens: tokens)
                    await MainActor.run {
                        self.output = text
                    }
                }

                if tokens.count >= maxTokens {
                    return .stop
                } else {
                    return .more
                }
            }

            await MainActor.run {
                if result.output != output {
                    output = result.output
                }
                running = false
                self.tokensPerSecond = result.tokensPerSecond
            }
        } catch {
            await MainActor.run {
                showErrorToast(error)
                running = false
            }
        }
    }

    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(output, forType: .string)
        showToast("Copied!")
    }

    func showToast(_ title: String) {
        if !title.isEmpty {
            showToast = true
            toastTitle = title
        }
    }

    func showErrorToast(_ error: Error) {
        showErrorToast = true
        self.error = error.localizedDescription
    }
}
