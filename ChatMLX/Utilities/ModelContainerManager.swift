//
//  ModelContainerManager.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import SwiftUI
import SwiftData

class ModelContainerManager: Observable {
    var modelContainer: ModelContainer?
    var errorMessage: String?

    func createModelContainer() {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            self.errorMessage = "Failed to create model container: \(error.localizedDescription)"
        }
    }
}
