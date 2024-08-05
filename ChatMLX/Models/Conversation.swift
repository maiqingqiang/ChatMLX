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
    var title: String
    var model: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var messages: [Message] = []
    
    var temperature: Double
    var topK: Int
    var maxLength: Int
    
    init(title: String, model: String, temperature: Double = 0.7, topK: Int = 50, maxLength: Int = 1000) {
        self.title = title
        self.model = model
        self.createdAt = Date()
        self.updatedAt = Date()
        
        self.temperature = temperature
        self.topK = topK
        self.maxLength = maxLength
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
        message.content += content
        updatedAt = Date()
    }
      
    func completeStreamingMessage(_ message: Message) {
        message.isComplete = true
        updatedAt = Date()
    }
}
