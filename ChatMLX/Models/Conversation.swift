//
//  Conversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import Defaults
import Foundation
import SwiftData

@Model
class Conversation {
    var title: String = "Default Conversation"
    var model: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    @Relationship(deleteRule: .cascade) var messages: [Message] = []

    var temperature: Float = 0.6
    var topP: Float = 1
    var maxLength: Int = 1000
    var repetitionContextSize: Int = 20

    var promptTime: TimeInterval?
    var generateTime: TimeInterval?
    var promptTokensPerSecond: Double?
    var tokensPerSecond: Double?

    var maxMessagesLimit: Int = 10
    var useMaxMessagesLimit: Bool = false

    init() {
        model = Defaults[.defaultModel]
    }

    func addMessage(_ message: Message) {
        messages.append(message)
        updatedAt = Date()
    }

    func startStreamingMessage(role: Message.Role) -> Message {
        let message = Message(role: role, isComplete: false)
        addMessage(message)
        return message
    }

    func updateStreamingMessage(_ message: Message, with content: String) {
        message.content = content
        updatedAt = Date()
    }

    func completeStreamingMessage(_ message: Message) {
        message.isComplete = true
        updatedAt = Date()
    }

    func failedMessage(_ message: Message, with error: Error) {
        message.isComplete = true
        message.error = error.localizedDescription
        updatedAt = Date()
    }

    func clearMessages() {
        messages.removeAll()
        updatedAt = Date()
    }
}
