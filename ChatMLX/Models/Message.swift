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
    }
    
    var role: Role
    var content: String
    var timestamp: Date
    
    init(role: Role, content: String, timestamp: Date = Date()) {
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
