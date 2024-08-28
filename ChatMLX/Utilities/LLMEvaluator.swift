//
//  LLMEvaluator.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/14.
//

import MLX
import MLXLLM
import MLXRandom
import Metal
import SwiftUI
import Tokenizers

@Observable
@MainActor
class LLMEvaluator {
    var running = false

    var output = ""
    var modelInfo = ""
    var stat = ""

    /// this controls which model loads -- phi4bit is one of the smaller ones so this will fit on
    /// more devices
    //    let modelConfiguration = ModelConfiguration.phi3_4bit
    var modelConfiguration: ModelConfiguration

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.6)
    let maxTokens = 240

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token
    let displayEveryNTokens = 4

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle

    init(modelConfiguration: ModelConfiguration? = nil) {
        if let modelConfiguration {
            self.modelConfiguration = modelConfiguration
        } else {
            self.modelConfiguration = ModelConfiguration(
                id: "mlx-community/OpenELM-270M")
        }
    }

    func changeModel(to newConfiguration: ModelConfiguration) {
        guard !running else { return }
        modelConfiguration = newConfiguration
        loadState = .idle
        output = ""
        modelInfo = ""
        stat = ""
    }

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
    func load() async throws -> ModelContainer {
        switch loadState {
        case .idle:
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            print("modelConfiguration \(modelConfiguration)")

            let modelContainer = try await MLXLLM.loadModelContainer(
                configuration: modelConfiguration
            ) {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                        "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                }
            }
            modelInfo =
                "Loaded \(modelConfiguration.id).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M"
            loadState = .loaded(modelContainer)
            return modelContainer

        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    func generate(conversation: Conversation) async {
        guard !running else { return }

        running = true
        output = ""

        do {
            let modelContainer = try await load()

            let extraEOSTokens = modelConfiguration.extraEOSTokens

            let messages = conversation.messages
                .sorted { $0.timestamp < $1.timestamp }
                .map { message in
                    ["role": message.role.rawValue, "content": message.content]
                }

            let messageTokens = try await modelContainer.perform {
                _, tokenizer in
                try tokenizer.applyChatTemplate(messages: messages)
            }

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = await modelContainer.perform { model, tokenizer in
                MLXLLM.generate(
                    promptTokens: messageTokens, parameters: generateParameters,
                    model: model,
                    tokenizer: tokenizer, extraEOSTokens: extraEOSTokens
                ) { tokens in
                    // update the output -- this will make the view show the text as it generates
                    if tokens.count % displayEveryNTokens == 0 {
                        let text = tokenizer.decode(tokens: tokens)
                        Task { @MainActor in
                            self.output = text
                        }
                    }

                    if tokens.count >= maxTokens {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
            if result.output != output {
                output = result.output
            }
            stat =
                " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"

        } catch {
            output = "Failed: \(error)"
        }

        running = false
    }
}
