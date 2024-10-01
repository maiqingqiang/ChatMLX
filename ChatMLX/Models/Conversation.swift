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
final class Conversation {
    var title: String
    var model: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var messages: [Message] = []

    var sortedMessages: [Message] {
        return messages.sorted { $0.updatedAt < $1.updatedAt }
    }

    var temperature: Float
    var topP: Float
    var useMaxLength: Bool
    var maxLength: Int
    var repetitionContextSize: Int

    var maxMessagesLimit: Int
    var useMaxMessagesLimit: Bool

    var useRepetitionPenalty: Bool
    var repetitionPenalty: Float

    var useSystemPrompt: Bool
    var systemPrompt: String

    var promptTime: TimeInterval?
    var generateTime: TimeInterval?
    var promptTokensPerSecond: Double?
    var tokensPerSecond: Double?

    static var all: FetchDescriptor<Conversation> {
        FetchDescriptor(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
    }

    init() {
        title = Defaults[.defaultTitle]
        model = Defaults[.defaultModel]
        temperature = Defaults[.defaultTemperature]
        topP = Defaults[.defaultTopP]
        useMaxLength = Defaults[.defaultUseMaxLength]
        maxLength = Defaults[.defaultMaxLength]
        repetitionContextSize = Defaults[.defaultRepetitionContextSize]
        repetitionPenalty = Defaults[.defaultRepetitionPenalty]
        maxMessagesLimit = Defaults[.defaultMaxMessagesLimit]
        useMaxMessagesLimit = Defaults[.defaultUseMaxMessagesLimit]
        useRepetitionPenalty = Defaults[.defaultUseRepetitionPenalty]
        repetitionPenalty = Defaults[.defaultRepetitionPenalty]
        useSystemPrompt = Defaults[.defaultUseSystemPrompt]
        systemPrompt = Defaults[.defaultSystemPrompt]

        createdAt = .init()
        updatedAt = .init()
    }

    func addMessage(_ message: Message) {
        messages.append(message)
        updatedAt = Date()
    }

    func startStreamingMessage(role: Message.Role) -> Message {
        let message = Message(role: role)
        message.inferring = true
        addMessage(message)
        return message
    }

    func updateStreamingMessage(_ message: Message, with content: String) {
        message.content = content
        updatedAt = Date()
    }

    func completeStreamingMessage(_ message: Message) {
        message.inferring = false
        updatedAt = Date()
    }

    func failedMessage(_ message: Message, with error: Error) {
        message.inferring = false
        message.error = error.localizedDescription
        updatedAt = Date()
    }

    func clearMessages() {
        messages.removeAll()
        updatedAt = Date()
    }
}
