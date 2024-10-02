//
//  Message.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import Foundation
import SwiftData

@Model
final class MessageSW {
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }

    var role: Role
    var content: String

    @Transient var inferring: Bool = false

    var createdAt: Date
    var updatedAt: Date

    var error: String?

    var conversation: ConversationSW?

    init(
        role: Role,
        content: String = ""
    ) {
        self.role = role
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
