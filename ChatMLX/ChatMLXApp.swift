//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/17.
//

import SwiftData
import SwiftUI

@main
struct ChatMLXApp: App {
    @State var chatViewModel: ChatViewModel
    @State var settingsViewModel: SettingsViewModel
    @State var promptViewModel: PromptViewModel
    @State var appViewModel: AppViewModel
    @State var appStroe: AppStroe

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Conversation.self,
            Message.self,
        ])
        let modelConfiguration = SwiftData.ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

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
        _promptViewModel = State(wrappedValue: PromptViewModel())
        _appViewModel = State(wrappedValue: AppViewModel())
        _appStroe = State(wrappedValue: AppStroe())
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(chatViewModel)
                .environment(promptViewModel)
                .environment(appViewModel)
                .environment(appStroe)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        

        Settings {
            SettingsView()
                .environment(SettingsViewModel())
        }
        .windowResizability(.contentSize)
    }
}
