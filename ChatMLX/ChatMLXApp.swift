//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/2/28.
//

import Features
import SwiftUI

@main
struct ChatMLXApp: App {
     @State var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(chatViewModel)
        }
    }
}
