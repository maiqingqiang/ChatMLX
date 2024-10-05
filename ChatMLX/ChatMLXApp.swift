//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import SwiftUI

@main
struct ChatMLXApp: App {
    @Environment(\.scenePhase) private var scenePhase

    @State private var conversationViewModel: ConversationViewModel = .init()
    @State private var settingsViewModel: SettingsViewModel = .init()
    @State private var runner: LLMRunner = .init()

    @Default(.language) var language

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ConversationView()
                .environment(conversationViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
                .environment(runner)
                .frame(minWidth: 900, minHeight: 580)
                .errorAlert(
                    isPresented: $conversationViewModel.showErrorAlert,
                    title: $settingsViewModel.errorTitle,
                    error: $conversationViewModel.error
                )
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background {
                let context = persistenceController.container.viewContext
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        logger.error(
                            "scenePhase.background save error: \(error.localizedDescription)")
                    }
                }
            }
        }

        Settings {
            SettingsView()
                .environment(conversationViewModel)
                .environment(settingsViewModel)
                .environment(
                    \.locale, .init(identifier: language.rawValue)
                )
                .environment(runner)
                .frame(width: 650, height: 480)
                .errorAlert(
                    isPresented: $settingsViewModel.showErrorAlert,
                    title: $settingsViewModel.errorTitle,
                    error: $settingsViewModel.error
                )
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
