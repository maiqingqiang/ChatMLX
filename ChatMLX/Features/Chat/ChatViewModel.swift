//
//  ChatViewModel.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation
import SwiftData
import SwiftUI
import MLX
import MLXRandom
import Tokenizers

@Observable
class ChatViewModel {
    var conversations: [Conversation] = []
    var content: String = ""

    var selectedConversation: Conversation?

    var selectedModel: String?

    var models: [MLXModel] = []

    var loadState = LoadState.idle

    @ObservationIgnored
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext

        let fetchDescriptor = FetchDescriptor<Conversation>(sortBy: [
            SortDescriptor<Conversation>(\.updatedAt, order: .reverse)
        ])
        conversations = try! self.modelContext.fetch(fetchDescriptor)

        if let model = UserDefaults.standard.string(forKey: Preferences.activeModel.rawValue) {
            selectedModel = model
        }
    }

    func load() async throws -> (LLMModel, Tokenizer) {
        switch loadState {
        case .idle:
            // limit the buffer cache
//            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
            let modelConfiguration = ModelConfiguration.configuration(id: selectedConversation!.model)
            let (model, tokenizer) = try await loadFromDisk(configuration: ModelConfiguration(id: selectedConversation!.model)) {
                [modelConfiguration] progress in
                DispatchQueue.main.sync {
                    print("Downloading \(modelConfiguration.id): \(Int(progress.fractionCompleted * 100))%")
                }
            }
            print("Loaded \(modelConfiguration.id).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M")
            loadState = .loaded(model, tokenizer)
            return (model, tokenizer)

        case .loaded(let model, let tokenizer):
            return (model, tokenizer)
        }
    }

    func add() {
        let activeModel = UserDefaults.standard.string(forKey: Preferences.activeModel.rawValue)
        if activeModel == nil || activeModel!.isEmpty {
            print("Not active model")
            return
        }

        let conversation = Conversation(model: activeModel!)
        withAnimation {
            conversations.append(conversation)
            selectedConversation = conversation
        }
        modelContext.insert(conversation)
        try! modelContext.save()
    }

    func delete(conversation: Conversation) {
        if let index = conversations.firstIndex(of: conversation) {
            withAnimation {
                conversations.remove(at: index)
                if conversation == selectedConversation {
                    selectedConversation = nil
                }
            }
            modelContext.delete(conversation)
        }
    }

    func submit() {
        if let conversation = selectedConversation,
           let index = conversations.firstIndex(of: conversation)
        {
            withAnimation {
                let conversation = conversations[index]

                if conversation.messages.isEmpty, conversation.name.isEmpty {
                    conversation.name = String(content.prefix(20))
                }

                conversation.messages.append(Message(role: .user, content: content))
                Task{
                    await generate(prompt: content)
                }
                conversation.updatedAt = .now
                content = ""
            }
            
            
            
            try! modelContext.save()
        } else {
            add()
            submit()
        }
    }
    
    func generate(prompt: String) async {
            do {
                let (model, tokenizer) = try await load()

//                await MainActor.run {
//                    running = true
//                    self.output = ""
//                }

                let modelConfiguration = ModelConfiguration.configuration(id: selectedConversation!.model)
                // augment the prompt as needed
                let prompt = modelConfiguration.prepare(prompt: prompt)
                
                print(prompt)
                
                let promptTokens = MLXArray(tokenizer.encode(text: prompt))

                // each time you generate you will get something new
                MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

                var outputTokens = [Int]()
                let message = Message(role: .assistant, content: "")
                let index = conversations.firstIndex(of: selectedConversation!)!
                await MainActor.run {
                    conversations[index].messages.append(message)
                }
                
                let messageIndex = conversations[index].messages.firstIndex(of: message)!
                for token in TokenIterator(prompt: promptTokens, model: model, temp: selectedConversation!.temperature) {
                    let tokenId = token.item(Int.self)

                    if tokenId == tokenizer.unknownTokenId || tokenId == tokenizer.eosTokenId {
                        break
                    }

                    outputTokens.append(tokenId)
                    let text = tokenizer.decode(tokens: outputTokens)

                    // update the output -- this will make the view show the text as it generates
                    await MainActor.run {
                        self.conversations[index].messages[messageIndex].content = text
                    }
                    print(text)

                    if outputTokens.count == selectedConversation!.maxToken {
                        break
                    }
                }

//                await MainActor.run {
//                    running = false
//                }

            } catch {
//                await MainActor.run {
//                    running = false
//                    output = "Failed: \(error)"
//                }
                print("Generate Failed: \(error)")
            }
        }

    func loadFromModelDirectory() {
        let models = ModelUtility.loadFromModelDirectory()
        self.models.removeAll()
        for model in models {
            self.models.append(MLXModel(name: model))
        }
    }
}
