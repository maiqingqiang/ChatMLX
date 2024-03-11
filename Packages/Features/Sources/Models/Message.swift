//
//  Message.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import Foundation

enum Role: String {
    case assistant = "Assistant"
    case user = "User"
}

struct Message {
    let id: UUID = .init()
    let content: String
    let role: Role
    let createdAt: Date = .now
}

extension Message: Equatable, Hashable, Identifiable {}
