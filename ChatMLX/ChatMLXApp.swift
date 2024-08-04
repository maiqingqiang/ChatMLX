//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftData
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

@main
struct ChatMLXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Conversation.self, Message.self])

        
        Settings {
            Text("test")
        }
    }
}
