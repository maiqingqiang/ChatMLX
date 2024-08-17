//
//  ChatView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//
import SwiftUI

struct ChatView: View {
    @State private var sidebarWidth: CGFloat = 250
    @State private var selectedConversation: Conversation?

    var body: some View {
        UltramanNavigationSplitView(sidebarWidth: $sidebarWidth, sidebar: {
            ChatSidebarView(selectedConversation: $selectedConversation)
        }, detail: {
            Group {
                if let conversation = selectedConversation {
                    DetailView(conversation: conversation)
                } else {
                    EmptyChat()
                }
            }
        })
        .foregroundColor(.white)
    }
}

#Preview {
    ChatView()
}
