//
//  ChatViewModel.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Cmlx
import Foundation
import MLX
import MLXRandom
import SwiftData
import SwiftUI
import Tokenizers
import MLXLLM

@Observable
class ChatViewModel {
    var selectedConversationID: Conversation.ID?
    var selectedDisplayStyle:DisplayStyle = .markdown
    
    func conversation() -> Conversation? {
        conversations.first(where: { $0.id == selectedConversationID })
    }
    
    
    
    var conversations: [Conversation] = []
    var content: String = ""

    var selectedConversation: Conversation?
    

    var selectedModel: String?

    var models: [MLXModel] = []

    var loadState = ModelState.idle
    
    var showToast: Bool = false
    var toastTitle: String = ""

    var showErrorToast: Bool = false
    var error: String = ""

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
    
    func copyToClipboard(_ text:String) {
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
    
    
    

    func load() async -> (LLMModel, Tokenizer)? {
//        if let conversation = selectedConversation {
//            switch loadState {
//            case .idle:
//                // limit the buffer cache
//                MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
//                
//                let modelConfiguration = ModelConfiguration.configuration(id: conversation.model)
//                do {
//                    let (model, tokenizer) = try await loadFromDisk(configuration: ModelConfiguration(id: selectedConversation!.model)) {
//                        [modelConfiguration] progress in
//                            print("Downloading \(modelConfiguration.id): \(Int(progress.fractionCompleted * 100))%")
//                    }
//                    
//                    print("Loaded \(modelConfiguration.id).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M")
//                    loadState = .loaded(modelConfiguration.id, model, tokenizer)
//                    return (model, tokenizer)
//                } catch {}
//            case .loaded(let modelName, let model, let tokenizer):
//                if conversation.model != modelName {
//                    loadState = .idle
//                    return await load()
//                }
//                return (model, tokenizer)
//            }
//        }
        
        return nil
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
                Task {
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
            if let (model, tokenizer) = await load() {
                //                await MainActor.run {
                //                    running = true
                //                    self.output = ""
                //                }
                
                let modelConfiguration = ModelConfiguration.configuration(id: selectedConversation!.model)
                // augment the prompt as needed
//                let prompt = modelConfiguration.prepare(prompt: prompt)
                
                print(prompt)
                let index = conversations.firstIndex(of: selectedConversation!)!
                var messages: [[String: String]] = []
                for message in conversations[index].messages.sorted(by: { $0.createdAt < $1.createdAt }) {
                    messages.append([
                        "role": message.role.rawValue,
                        "content": message.content
                    ])
                }
            
                print(messages)
            
                let promptTokens = try MLXArray(tokenizer.applyChatTemplate(messages: messages))
                
                // each time you generate you will get something new
//                MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))
                
                var outputTokens = [Int]()
                let message = Message(role: .assistant, content: "")
            
                await MainActor.run {
                    conversations[index].messages.append(message)
                }
                
                let messageIndex = conversations[index].messages.firstIndex(of: message)!
//                for token in TokenIterator(prompt: promptTokens, model: model, temp: selectedConversation!.temperature) {
//                    let tokenId = token.item(Int.self)
//                    
//                    if tokenId == tokenizer.unknownTokenId || tokenId == tokenizer.eosTokenId {
//                        break
//                    }
//                    
//                    outputTokens.append(tokenId)
//                    let text = tokenizer.decode(tokens: outputTokens)
//                    
//                    // update the output -- this will make the view show the text as it generates
//                    await MainActor.run {
//                        self.conversations[index].messages[messageIndex].content = text
//                    }
//                    print(text)
//                    
//                    if outputTokens.count == selectedConversation!.maxToken {
//                        break
//                    }
//                }
                
                //                await MainActor.run {
                //                    running = false
                //                }
            }
        } catch {
            print("\(error)")
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
