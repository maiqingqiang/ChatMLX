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
    @State private var conversationViewModel: ConversationView.ViewModel = .init()
    @State private var settingsViewModel: SettingsView.ViewModel = .init()

    @Default(.language) var language
    @State private var runner = LLMRunner()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Conversation.self, Message.self])

        let url = URL.applicationSupportDirectory.appending(path: "ChatMLX/Store.sqlite")

        let modelConfiguration = ModelConfiguration(url: url)

        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ConversationView()
                .environment(conversationViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
                .environment(runner)
                .frame(minWidth: 900, minHeight: 580)
        }
        .modelContainer(sharedModelContainer)

        Settings {
            SettingsView()
                .environment(conversationViewModel)
                .environment(settingsViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
                .environment(runner)
                .frame(width: 620, height: 480)
        }
        .modelContainer(sharedModelContainer)
    }
}
