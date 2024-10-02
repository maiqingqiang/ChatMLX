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
final class ConversationSW {
    var title: String
    var model: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var messages: [MessageSW] = []

    var sortedMessages: [MessageSW] = []

    var temperature: Float
    var topP: Float
    var useMaxLength: Bool
    var maxLength: Int64
    var repetitionContextSize: Int32

    var maxMessagesLimit: Int32
    var useMaxMessagesLimit: Bool

    var useRepetitionPenalty: Bool
    var repetitionPenalty: Float

    var useSystemPrompt: Bool
    var systemPrompt: String

    var promptTime: TimeInterval?
    var generateTime: TimeInterval?
    var promptTokensPerSecond: Double?
    var tokensPerSecond: Double?

    static var all: FetchDescriptor<ConversationSW> {
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

    func addMessage(_ message: MessageSW) {
        messages.append(message)
        updatedAt = Date()
    }

    func startStreamingMessage(role: MessageSW.Role) -> MessageSW {
        let message = MessageSW(role: role)
        message.inferring = true
        addMessage(message)
        return message
    }

    func updateStreamingMessage(_ message: MessageSW, with content: String) {
        message.content = content
        updatedAt = Date()
    }

    func completeStreamingMessage(_ message: MessageSW) {
        message.inferring = false
        updatedAt = Date()
    }

    func failedMessage(_ message: MessageSW, with error: Error) {
        message.inferring = false
        message.error = error.localizedDescription
        updatedAt = Date()
    }

    func clearMessages() {
        messages.removeAll()
        updatedAt = Date()
    }
}
