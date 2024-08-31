//
//  ConversationView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//
import SwiftUI

struct ConversationView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        UltramanNavigationSplitView(
            sidebar: {
                ConversationSidebarView(
                    selectedConversation: $viewModel.selectedConversation)
            },
            detail: {
                Detail()
            }
        )
        .foregroundColor(.white)
        .ultramanMinimalistWindowStyle()
    }

    @ViewBuilder
    private func Detail() -> some View {
        Group {
            if let conversation = viewModel.selectedConversation {
                ConversationDetailView(
                    conversation: Binding(
                        get: { conversation },
                        set: { viewModel.selectedConversation = $0 }
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
