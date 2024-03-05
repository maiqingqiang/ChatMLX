//
//  Chat.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/2.
//

import Foundation

struct Chat: Equatable, Identifiable {
    var id: UUID = .init()
    var model: String = ""
    var messages: [Message] = []
}
