//
//  LLMRunner.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/24.
//
import Metal
import MLX
import MLXLLM
import MLXRandom
import SwiftUI
import Tokenizers

@Observable
@MainActor
class LLMRunner {
    var running = false
    var model: String?

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState: LoadState = .idle

    var modelConfiguration: ModelConfiguration?

    var gpuActiveMemory: Int = 0

    let displayEveryNTokens = 4

    private func load() async throws -> ModelContainer? {
        guard let modelConfiguration else {
            throw LLMRunnerError.modelConfigurationNotSet
        }

        switch loadState {
        case .idle:
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let modelContainer = try await MLXLLM.loadModelContainer(
                configuration: modelConfiguration
            )

            withAnimation {
                gpuActiveMemory = MLX.GPU.activeMemory / 1024 / 1024
            }
            
            loadState = .loaded(modelContainer)
            return modelContainer

        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    func generate(conversation: Conversation) async {
        guard !running else { return }
        running = true

        do {
            if conversation.model != modelConfiguration?.name {
                loadState = .idle
                modelConfiguration = ModelConfiguration.configuration(id: conversation.model)
            }

            if let modelConfiguration {
                guard let modelContainer = try await load() else {
                    throw LLMRunnerError.failedToLoadModel
                }

                let chatMessages = conversation.messages
                    .sorted { $0.timestamp < $1.timestamp }
                    .map { message in
                        ["role": message.role.rawValue, "content": message.content]
                    }

                let messageTokens = try await modelContainer.perform {
                    _, tokenizer in
                    try tokenizer.applyChatTemplate(messages: chatMessages)
                }

                MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

                let message = conversation.startStreamingMessage(role: .assistant)

                let result = await modelContainer.perform {
                    model,
                        tokenizer in
                    MLXLLM.generate(
                        promptTokens: messageTokens,
                        parameters: GenerateParameters(
                            temperature: conversation.temperature,
                            topP: conversation.topP,
                            repetitionContextSize: conversation.repetitionContextSize
                        ),
                        model: model,
                        tokenizer: tokenizer,
                        extraEOSTokens: modelConfiguration.extraEOSTokens
                    ) { tokens in
                        if tokens.count % displayEveryNTokens == 0 {
                            DispatchQueue.main.async {
                                let text = tokenizer.decode(tokens: tokens)
                                message.content = text
                            }
                        }

                        return tokens.count >= conversation.maxLength ? .stop : .more
                    }
                }

                if result.output != message.content {
                    message.content = result.output
                }

                conversation.completeStreamingMessage(
                    message)
                conversation.promptTime = result.promptTime
                conversation.generateTime = result.generateTime
                conversation.promptTokensPerSecond = result.promptTokensPerSecond
                conversation.tokensPerSecond = result.tokensPerSecond
            }
        } catch {
            print("Failed: \(error)")
        }

        running = false
    }
}

enum LLMRunnerError: Error {
    case modelConfigurationNotSet
    case failedToLoadModel
}