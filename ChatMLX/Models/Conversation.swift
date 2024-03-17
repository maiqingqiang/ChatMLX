//
//  Conversation.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation
import SwiftData

@Model
public final class Conversation {
    @Attribute(.unique) public let id: UUID = UUID()

    var messages: [Message] = []

    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now

    var name: String = ""
    var model: String
    var prompt: String = "You are a helpful assistant"
    var temperature: Float = 0.7
    var topK: Int = 1
    var maxToken: Int = 128

    init(model: String, messages: [Message] = []) {
        self.model = model
        self.messages = messages
    }
}

extension Conversation: Equatable, Hashable, Identifiable {
    public static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
