//
//  ConversationViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/3.
//

import SwiftUI

@Observable
class ConversationViewModel {
    var detailWidth: CGFloat = 550
    var selectedConversation: Conversation?
    var error: Error?
    var errorTitle: String?
    var showErrorAlert = false

    func throwError(_ error: Error, title: String? = nil) {
        logger.error("\(error.localizedDescription)")
        self.error = error
        errorTitle = title
        showErrorAlert = true
    }

    func createConversation() {
        do {
            let context = PersistenceController.shared.container.viewContext
            let conversation = Conversation(context: context)
            try PersistenceController.shared.save()
            selectedConversation = conversation
        } catch {
            throwError(error, title: "Create Conversation Failed")
        }
    }
}
