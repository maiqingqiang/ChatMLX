//
//  EmptyConversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftUI

struct EmptyConversation: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ConversationViewModel.self) private var conversationViewModel

    var body: some View {
        ContentUnavailableView {
            Label("No Conversation", systemImage: "tray.fill")
                .foregroundColor(.white)
        } description: {
            Text("Please select a new conversation")
                .foregroundColor(.white)
            Button(
                action: conversationViewModel.createConversation,
                label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                        Text("New Conversation")
                    }
                    .foregroundColor(.white)
                }
            ).buttonStyle(LuminareCompactButtonStyle())
                .fixedSize()
        }
    }
}
