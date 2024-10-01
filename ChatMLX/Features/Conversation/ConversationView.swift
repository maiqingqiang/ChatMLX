//
//  ConversationView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftUI

struct ConversationView: View {
    @Environment(ViewModel.self) private var conversationViewModel

    var body: some View {
        @Bindable var conversationViewModel = conversationViewModel

        UltramanNavigationSplitView(
            sidebar: {
                ConversationSidebarView(
                    selectedConversation: $conversationViewModel.selectedConversation)
            },
            detail: {
                Detail()
            }
        )
        .foregroundColor(.white)
        .ultramanMinimalistWindowStyle()
    }

    @MainActor
    @ViewBuilder
    private func Detail() -> some View {
        Group {
            if let conversation = conversationViewModel.selectedConversation {
                ConversationDetailView(
                    conversation: Binding(
                        get: { conversation },
                        set: { conversationViewModel.selectedConversation = $0 }
                    ))
            } else {
                EmptyConversation()
            }
        }
    }
}

extension ConversationView {
    @Observable
    class ViewModel {
        var detailWidth: CGFloat = 550
        var selectedConversation: Conversation?
    }
}

#Preview {
    ConversationView()
}
