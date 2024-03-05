//
//  Message.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/2.
//

import Foundation

enum Role: String {
    case assistant = "Assistant"
    case user = "User"
}

struct Message: Equatable, Identifiable {
    var id: UUID = .init()

    var role: Role
    var content: String
    var done: Bool = false
    var error: Bool = false
    var createdAt: Date = .now
}
