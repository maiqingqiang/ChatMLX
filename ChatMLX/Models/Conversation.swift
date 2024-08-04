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
    
    init(title: String, model: String) {
        self.title = title
        self.model = model
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func addMessage(_ message: Message) {
        messages.append(message)
        updatedAt = Date()
    }
}
