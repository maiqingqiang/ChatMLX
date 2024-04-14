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
        case assistant
        case user
    }

    @Attribute(.unique) public var id: UUID = UUID()

    var role: Role
    var content: String = ""

    var createdAt: Date = Date.now
    
    init(role: Role) {
        self.role = role
    }

    init(role: Role, content: String) {
        self.role = role
        self.content = content
    }
    
    func appendContent(_ content:String) {
        self.content += content
    }
    
    func updateContent(_ content:String) {
        self.content = content
    }
}

extension Message: Equatable, Hashable, Identifiable {}
