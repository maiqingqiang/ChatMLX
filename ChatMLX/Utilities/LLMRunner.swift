//
//  LLMRunner.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/24.
//

import Defaults
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

    init() {}

    private func load() async throws -> ModelContainer? {
        guard let modelConfiguration else {
            throw LLMRunnerError.modelConfigurationNotSet
        }

        switch loadState {
        case .idle:
            let cacheLimit =
                UserDefaults.standard.integer(
                    forKey: Defaults.Keys.gpuCacheLimit.name) * 1024 * 1024
            MLX.GPU.set(cacheLimit: cacheLimit)

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

    func generate(message: String, conversation: Conversation, in context: NSManagedObjectContext) async {
        guard !running else { return }

        await MainActor.run {
            running = true
        }

        let userMessage = Message(context: context)
        userMessage.role = MessageSW.Role.user.rawValue
        userMessage.content = message
        userMessage.conversation = conversation

//        let message = conversation.startStreamingMessage(role: .assistant)

        let assistantMessage = Message(context: context)
        assistantMessage.role = MessageSW.Role.assistant.rawValue
        assistantMessage.inferring = true
        assistantMessage.content = ""
        assistantMessage.conversation = conversation

        do {
            if conversation.model != modelConfiguration?.name {
                loadState = .idle
                modelConfiguration = ModelConfiguration.configuration(
                    id: conversation.model)
            }

            if let modelConfiguration {
                guard let modelContainer = try await load() else {
                    throw LLMRunnerError.failedToLoadModel
                }

                var messages = conversation.messages

                if conversation.useMaxMessagesLimit {
                    let maxCount = conversation.maxMessagesLimit + 1
                    if messages.count > maxCount {
                        messages = Array(messages.suffix(Int(maxCount)))
                        if messages.first?.role != MessageSW.Role.user.rawValue {
                            messages = Array(messages.dropFirst())
                        }
                    }
                }

//                if conversation.useSystemPrompt, !conversation.systemPrompt.isEmpty {
//                    messages.insert(
//                        Message(
//                            role: .system,
//                            content: conversation.systemPrompt
//                        ),
//                        at: 0
//                    )
//                }

                let messagesDicts = messages[..<(messages.count - 1)].map {
                    message -> [String: String] in
                    ["role": message.role, "content": message.content]
                }

                print("messagesDicts", messagesDicts)

                let messageTokens = try await modelContainer.perform {
                    _, tokenizer in
                    try tokenizer.applyChatTemplate(messages: messagesDicts)
                }

                MLXRandom.seed(
                    UInt64(Date.timeIntervalSinceReferenceDate * 1000))

                let result = await modelContainer.perform {
                    model,
                        tokenizer in

                    MLXLLM.generate(
                        promptTokens: messageTokens,
                        parameters: GenerateParameters(
                            temperature: conversation.temperature,
                            topP: conversation.topP,
                            repetitionPenalty: conversation.useRepetitionPenalty
                                ? conversation.repetitionPenalty : nil,
//                            repetitionContextSize: Int(conversation.repetitionContextSize)
                            repetitionContextSize: 20
                        ),
                        model: model,
                        tokenizer: tokenizer,
                        extraEOSTokens: modelConfiguration.extraEOSTokens.union([
                            "<|im_end|>", "<|end|>",
                        ])
                    ) { tokens in
                        if tokens.count % displayEveryNTokens == 0 {
                            let text = tokenizer.decode(tokens: tokens)
                            print("assistantMessage.content ->", text)
                            Task { @MainActor in
                                assistantMessage.content = text
                            }
                        }

                        if conversation.useMaxLength, tokens.count >= conversation.maxLength {
                            return .stop
                        }
                        return .more
                    }
                }

                await MainActor.run {
                    if result.output != assistantMessage.content {
                        assistantMessage.content = result.output
                    }

                    assistantMessage.inferring = false
                    conversation.promptTime = result.promptTime
                    conversation.generateTime = result.generateTime
                    conversation.promptTokensPerSecond =
                        result.promptTokensPerSecond
                    conversation.tokensPerSecond = result.tokensPerSecond
                }
            }
        } catch {
            print("\(error)")
            logger.error("LLM Generate Failed: \(error.localizedDescription)")
//            await MainActor.run {
//                conversation.failedMessage(message, with: error)
//            }
        }
        await MainActor.run {
            running = false
        }
    }
}

enum LLMRunnerError: Error {
    case modelConfigurationNotSet
    case failedToLoadModel
}
