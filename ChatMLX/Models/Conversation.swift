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

    var sortedMessages: [Message] {
        messages.sorted(by: { $0.createdAt < $1.createdAt })
    }

    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now

    var name: String = ""
    var selectedModel: String = ""
    var historyLimit: Int = 10

    var prompt: String = "You are a helpful assistant"
    var temperature: Float = 0.7
    var topP: Float = 0.9
    var maxTokens: Int = 256
    var repetitionPenalty: Float = 1.0
    var repetitionContextSize: Int = 20

    var running: Bool = false
    var stopping: Bool = false

    init() {}

    init(model: String) {
        selectedModel = model
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
