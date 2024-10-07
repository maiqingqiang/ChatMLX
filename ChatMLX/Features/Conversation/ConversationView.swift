//
//  ConversationView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import SwiftUI

struct ConversationView: View {
    @Environment(ConversationViewModel.self) private var conversationViewModel
    @Environment(LLMRunner.self) private var runner

    @Default(.enableAppleIntelligenceEffect) var enableAppleIntelligenceEffect
    @Default(.appleIntelligenceEffectDisplay) var appleIntelligenceEffectDisplay

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
        .overlay {
            if enableAppleIntelligenceEffect, appleIntelligenceEffectDisplay == .appInternal,
                runner.running
            {
                AppleIntelligenceEffectView(useRoundedRectangle: false)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }

    @MainActor
    @ViewBuilder
    private func Detail() -> some View {
        Group {
            if let conversation = conversationViewModel.selectedConversation {
                ConversationDetailView(
                    conversation: conversation
                ).id(conversation.id)
            } else {
                EmptyConversation()
            }
        }
    }
}

#Preview {
    ConversationView()
}
