//
//  Message.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation
import SwiftData

@Model
public final class Message {
    enum Role: String, Codable {
        case assistant = "Assistant"
        case user = "User"
    }

    @Attribute(.unique) public var id: UUID = UUID()

    var role: Role
    var content: String

    var createdAt: Date = Date.now

    //    @Relationship var conversation: Conversation?

    init(role: Role, content: String) {
        self.role = role
        self.content = content
    }
}

extension Message: Equatable, Hashable, Identifiable {}
