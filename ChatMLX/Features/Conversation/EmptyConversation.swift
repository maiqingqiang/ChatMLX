//
//  EmptyConversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftUI

struct EmptyConversation: View {
    @Environment(ConversationViewModel.self) private var conversationViewModel

    var body: some View {
        ContentUnavailableView {
            Label("No Conversation", systemImage: "tray.fill")
        } description: {
            Text("Please select a new conversation")

            Button(action: conversationViewModel.createConversation) {
                Label("New Conversation", systemImage: "plus")
            }
            .buttonStyle(LuminareCompactButtonStyle())
            .fixedSize()
        }
        .foregroundColor(.white)
    }
}
