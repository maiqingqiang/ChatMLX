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
    var showErrorAlert = false

    func throwError(error: Error) {
        self.error = error
        showErrorAlert = true
    }
    
    func createConversation() {
        do {
            let conversation = try PersistenceController.shared.createConversation()
            selectedConversation = conversation
        } catch {
            throwError(error: error)
        }
    }
}
