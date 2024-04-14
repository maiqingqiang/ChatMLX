//
//  ChatViewModel.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Cmlx
import Foundation
import MLX
import MLXLLM
import MLXRandom
import SwiftData
import SwiftUI
import Tokenizers

@Observable
class ChatViewModel {
    var selectedConversationID: Conversation.ID?
    var selectedDisplayStyle: DisplayStyle = .markdown

    var tableViewDelegate: TableViewDelegate = .init()

    func conversation() -> Conversation? {
        conversations.first(where: { $0.id == selectedConversationID })
    }

    var conversations: [Conversation] = []
    var content: String = ""

    var loadState = ModelState.idle

    var showToast: Bool = false
    var toastTitle: String = ""

    var showErrorToast: Bool = false
    var error: String = ""

    let displayEveryNTokens = 4

    @ObservationIgnored
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext

        let fetchDescriptor = FetchDescriptor<Conversation>(sortBy: [
            SortDescriptor<Conversation>(\.updatedAt, order: .reverse)
        ])
        conversations = try! self.modelContext.fetch(fetchDescriptor)
    }

    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
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

    func clear() {
        do {
            try modelContext.delete(model: Conversation.self)
            conversations = []
        }
        catch {
            print("clear error:\(error.localizedDescription)")
        }
    }

    func addConversation() {
        do {
            let conversation = Conversation()
            if let model = UserDefaults.standard.string(forKey: Preferences.defaultModel.rawValue) {
                conversation.selectedModel = model
            }
            withAnimation {
                conversations.append(conversation)
                selectedConversationID = conversation.id
            }
            modelContext.insert(conversation)
            try modelContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func removeConversation(conversation: Conversation) {
        if let index = conversations.firstIndex(of: conversation) {
            withAnimation {
                conversations.remove(at: index)
                if conversation.id == selectedConversationID {
                    selectedConversationID = nil
                }
            }
            modelContext.delete(conversation)
        }
    }

    func loadModel(_ conversation: Conversation) async throws -> (LLMModel, Tokenizers.Tokenizer) {
        switch loadState {
        case .idle:
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let (llmModel, tokenizer) = try await load(modelName: conversation.selectedModel) {
                progress in
                print(
                    "Downloading \(conversation.selectedModel): \(Int(progress.fractionCompleted * 100))%"
                )
            }

            loadState = .loaded(conversation.selectedModel, llmModel, tokenizer)
            return (llmModel, tokenizer)

        case .loaded(let model, let llmModel, let tokenizer):
            if conversation.selectedModel != model {
                loadState = .idle
                return try await loadModel(conversation)
            }
            return (llmModel, tokenizer)
        }
    }

    func submit(_ conversation: Conversation) async {
        let userMessage = Message(role: .user, content: content)
        let assistantMessage = Message(role: .assistant)

        let canRun = await MainActor.run {
            if conversation.running {
                return false
            }
            else {
                conversation.running = true
                conversation.messages.append(userMessage)
                conversation.messages.append(assistantMessage)
                return true
            }
        }

        guard canRun else { return }

        do {
            let (model, tokenizer) = try await loadModel(conversation)

            let promptTokens = tokenizer.encode(text: content)

            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = await MLXLLM.generate(
                promptTokens: promptTokens,
                parameters: GenerateParameters(
                    temperature: conversation.temperature,
                    topP: conversation.topP,
                    repetitionPenalty: conversation.repetitionPenalty,
                    repetitionContextSize: conversation.repetitionContextSize
                ),
                model: model,
                tokenizer: tokenizer
            ) { tokens in
                if tokens.count % displayEveryNTokens == 0 {
                    let text = tokenizer.decode(tokens: tokens)
                    print("text: \(text)")
                    await MainActor.run {
                        let index = conversation.messages.firstIndex(of: assistantMessage)!
                        conversation.messages[index].updateContent(text)
                    }
                }

                if tokens.count >= conversation.maxTokens {
                    return .stop
                }
                else {
                    return .more
                }
            }

            await MainActor.run {
                if result.output != assistantMessage.content {
                    assistantMessage.updateContent(result.output)
                }
                conversation.running = false
                //                self.tokensPerSecond = result.tokensPerSecond
            }
        }
        catch {
            await MainActor.run {
                showErrorToast(error)
                conversation.running = false
            }
        }
    }
}
