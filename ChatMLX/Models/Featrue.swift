//
//  Featrue.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import Foundation

struct Featrue: Identifiable, Hashable {
    enum Name: String {
        case prompt = "Prompt"
        case chat = "Chat"
    }

    let id = UUID()
    let name: Name
    let icon: String
}
