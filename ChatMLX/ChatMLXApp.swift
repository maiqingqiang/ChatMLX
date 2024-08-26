//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import SwiftData
import SwiftUI

@main
struct ChatMLXApp: App {
    @State private var chatViewModel = ChatView.ViewModel()
    @State private var downloadManagerViewModel =
        DownloadManagerView.ViewModel()
    @Default(.language) var language

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(chatViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
                .frame(minWidth: 900, minHeight: 580)
        }
        .modelContainer(for: [Conversation.self, Message.self])

        Settings {
            SettingsView()
                .environment(downloadManagerViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
        }
    }
}
