//
//  ChatView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//
import SwiftUI

struct ChatView: View {
    @State private var runner = LLMRunner()
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        UltramanNavigationSplitView(
            sidebarWidth: $viewModel.sidebarWidth,
            sidebar: {
                ChatSidebarView(
                    selectedConversation: $viewModel.selectedConversation)
            },
            detail: {
                Detail()
            }
        )
        .foregroundColor(.white)
        .environment(runner)
        .ultramanMinimalistWindowStyle()
    }

    @ViewBuilder
    private func Detail() -> some View {
        Group {
            if let conversation = viewModel.selectedConversation {
                ChatDetailView(
                    conversation: Binding(
                        get: { conversation },
                        set: { viewModel.selectedConversation = $0 }
                    ))
            } else {
                EmptyChat()
            }
        }
    }
}

extension ChatView {
    @Observable
    class ViewModel {
        var sidebarWidth: CGFloat = 250
        var detailWidth: CGFloat = 550
        var selectedConversation: Conversation?
    }
}

#Preview {
    ChatView()
}
