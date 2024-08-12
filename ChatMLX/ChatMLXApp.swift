//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftData
import SwiftUI

@main
struct ChatMLXApp: App {
    @State private var downloadManagerViewModel = DownloadManagerView.ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Conversation.self, Message.self])

        Settings {
            SettingsView()
                .environment(downloadManagerViewModel)
        }
    }
}
