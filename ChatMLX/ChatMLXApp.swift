//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/17.
//

import SwiftUI
import SwiftData

@main
struct ChatMLXApp: App {
    @State var chatViewModel: ChatViewModel
    @State var settingsViewModel: SettingsViewModel

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Conversation.self,
            Message.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        let modelContext = sharedModelContainer.mainContext
        _chatViewModel = State(wrappedValue: ChatViewModel(modelContext: modelContext))
        _settingsViewModel = State(wrappedValue: SettingsViewModel())
    }

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(chatViewModel)
        }
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
                .environment(SettingsViewModel())
        }
        .windowResizability(.contentSize)
    }
}
