//
//  ChatViewModel.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ChatViewModel {
    var conversations: [Conversation] = []
    var content: String = ""

    var selectedConversation: Conversation?

    var selectedModel: String?

    var models: [MLXModel] = []

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
                conversation.updatedAt = .now
                content = ""
            }
            try! modelContext.save()
        } else {
            add()
            submit()
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
