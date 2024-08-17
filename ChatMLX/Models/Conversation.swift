//
//  Conversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import Foundation
import SwiftData

@Model
class Conversation {
    var title: String = "Default Chat"
    var model: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    @Relationship(deleteRule: .cascade) var messages: [Message] = []

    var temperature: Double = 0.7
    var topK: Int = 50
    var maxLength: Int = 1000

    init() {}

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
        message.content += content
        updatedAt = Date()
    }

    func completeStreamingMessage(_ message: Message) {
        message.isComplete = true
        updatedAt = Date()
    }
}
