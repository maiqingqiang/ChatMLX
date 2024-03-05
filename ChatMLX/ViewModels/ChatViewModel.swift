//
//  ChatViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/2.
//

import AsyncAlgorithms
import Foundation
import MLX
import MLXRandom
import os
import SwiftUI

@Observable
class ChatViewModel {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "ChatViewModel")

    var histories: [Chat] = []

    var selectedChatID: Chat.ID?

    var selecting: Bool = false

    var content: String = ""

    func select(_ chat: Chat) {
        selectedChatID = chat.id
    }

    var modelDirectory: URL? {
        didSet {
            if let modelDirectory = modelDirectory {
                UserDefaults.standard.set(modelDirectory.absoluteString, forKey: "modelDirectory")
            } else {
                UserDefaults.standard.set(nil, forKey: "modelDirectory")
            }
        }
    }

    init() {
//        self.modelDirectory = URL(filePath: UserDefaults.standard.value(forKey: "modelDirectory") as? String ?? "")
    }

    func add() {
        let chat = Chat()
        withAnimation {
            histories.append(chat)
            if histories.count == 1 || selectedChatID == nil {
                selectedChatID = chat.id
            }
        }
    }

    func delete(_ chat: Chat) {
        withAnimation {
            histories.removeAll(where: { $0.id == chat.id })
            if chat.id == selectedChatID {
                selectedChatID = nil
            }
        }
    }

    var model: String = "mlx-community/Qwen1.5-0.5B-Chat-4bit"
//    var model: String = "mlx-community/quantized-gemma-2b-it"
//    var prompt = "compare python and swift"
    var temperature: Float = 0.6
    var seed: UInt64 = 0
    var maxTokens = 1024

    func submit() {
        if content.isEmpty {
            return
        }

        if histories.isEmpty || selectedChatID == nil {
            add()
        }
        let index = histories.firstIndex(where: { $0.id == selectedChatID })!

        histories[index].messages.append(Message(role: .user, content: content))
        let prompt = content
        content = ""

        let message = Message(role: .assistant, content: "")
        histories[index].messages.append(message)
        let messageIndex = histories[index].messages.firstIndex(of: message)!


        let modelDirectory = URL(filePath: UserDefaults.standard.value(forKey: "modelDirectory") as? String ?? "")

        XPCConnectionManager().generate(modelDirectory: modelDirectory, prompt: prompt, maxTokens: maxTokens, temperature: temperature, seed: seed) { _ in
            self.histories[index].messages[messageIndex].done = true
        } tokenizerDecoder: { token in
            self.histories[index].messages[messageIndex].content += token
        }
    }

    func tokenReceiver(token: String) {}
}
