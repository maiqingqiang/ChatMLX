//
//  Chat.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation

@Observable
class Conversation {
    let id: UUID = .init()

    var model: String
    var messages: [Message] = []

    init(model: String, messages: [Message] = []) {
        self.model = model
        self.messages = messages
    }
}

extension Conversation: Equatable, Hashable, Identifiable {
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
