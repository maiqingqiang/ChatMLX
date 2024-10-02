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
    @Environment(\.scenePhase) private var scenePhase

    @State private var conversationViewModel: ConversationViewModel = .init()
    @State private var settingsViewModel: SettingsView.ViewModel = .init()

    @Default(.language) var language

    @State private var runner = LLMRunner()

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
                .alert("Error", isPresented: $conversationViewModel.showErrorAlert, actions: {
                    Button("OK") {
                        conversationViewModel.error = nil
                    }

                    Button("Feedback") {
                        conversationViewModel.error = nil
                        NSWorkspace.shared.open(URL(string: "https://github.com/maiqingqiang/ChatMLX/issues")!)
                    }
                }, message: {
                    Text(conversationViewModel.error?.localizedDescription ?? "An unknown error occurred.")
                })
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .onChange(of: scenePhase) { _, _ in
            try? persistenceController.save()
        }

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
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
