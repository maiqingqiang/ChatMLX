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
    var maxTokens: Int = 128

    let displayEveryNTokens = 4

    var running: Bool = false
    var stopping: Bool = false

    var loadState = ModelState.idle

    var showToast: Bool = false
    var toastTitle: String = ""

    var showErrorToast: Bool = false
    var error: String = ""

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
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let (llmModel, tokenizer) = try await load(modelName: selectedModel) {
                [selectedModel] progress in
                print("Downloading \(selectedModel): \(Int(progress.fractionCompleted * 100))%")
            }

            print("Loaded \(selectedModel).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M")

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
        let startTime = Date()
        do {
            await MainActor.run {
                running = true
                output = ""
            }

            let (model, tokenizer) = try await loadModel()

            let promptTokens = MLXArray(tokenizer.encode(text: text))

            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            var outputTokens: [Int] = []

            for token in TokenIterator(prompt: promptTokens, model: model, temp: temperature, topP: topP) {
                if stopping {
                    stopping = false
                    break
                }
                let tokenId = token.item(Int.self)

                if tokenId == tokenizer.unknownTokenId || tokenId == tokenizer.eosTokenId {
                    break
                }

                outputTokens.append(tokenId)
                let text = tokenizer.decode(tokens: outputTokens)

                if outputTokens.count % displayEveryNTokens == 0 {
                    await MainActor.run {
                        output = text
                    }
                }

                if outputTokens.count == maxTokens {
                    break
                }
            }

            let finalText = tokenizer.decode(tokens: outputTokens)

            await MainActor.run {
                if finalText != output {
                    output = finalText
                }
                running = false
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
