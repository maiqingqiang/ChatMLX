//
//  ChatViewModel.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation
import SwiftUI

@Observable
public class ChatViewModel {
    var conversations: [Conversation] = []
    var content: String = ""

    var selectedConversation: Conversation?
    public init() {}

    init(selectedConversation: Conversation, conversations: [Conversation]) {
        self.conversations = conversations
        self.selectedConversation = selectedConversation
    }

    func add() {
        let conversation = Conversation(model: "")
        withAnimation {
            conversations.append(conversation)
            selectedConversation = conversation
        }
    }

    func remove(conversation: Conversation) {
        if let index = conversations.firstIndex(of: conversation) {
            withAnimation {
                conversations.remove(at: index)
                selectedConversation = nil
            }
        }
    }

    func submit() {
        if let conversation = selectedConversation, let index = conversations.firstIndex(of: conversation) {
            withAnimation {
                conversations[index].messages.append(Message(content: content, role: .user))
                content = ""
            }
        } else {
            add()
            submit()
        }
    }
}
