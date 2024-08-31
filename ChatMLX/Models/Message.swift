//
//  Message.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import Foundation
import SwiftData

@Model
class Message {
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }

    var role: Role
    var content: String
    var isComplete: Bool
    var timestamp: Date
    var error: String?

    init(
        role: Role,
        content: String = "",
        isComplete: Bool = false,
        timestamp: Date = Date()
    ) {
        self.role = role
        self.content = content
        self.isComplete = isComplete
        self.timestamp = timestamp
    }
}
