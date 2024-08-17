//
//  ChatSidebarItem.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import SwiftUI

struct ChatSidebarItem: View {
    let conversation: Conversation
    @Binding var selectedConversation: Conversation?
    
    @State private var isHovering: Bool = false
    @State private var isActive: Bool = false
    @State private var showIndicator: Bool = false
    
    private var sortedMessages: [Message] {
        conversation.messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    private var firstMessageContent: String {
        sortedMessages.first?.content ?? ""
    }
    
    private var lastMessageTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: conversation.messages.last?.timestamp ?? Date())
    }
    
    var body: some View {
        Button {
            selectedConversation = conversation
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.title)
                    .font(.headline)
                
                HStack {
                    Text(firstMessageContent)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(lastMessageTime)
                        .font(.caption)
                }
                .foregroundStyle(.white.opacity(0.7))
            }
            .padding(6)
        }
        .buttonStyle(UltramanSidebarButtonStyle(isActive: $isActive))
        .onAppear {
            checkIfSelfIsActiveTab()
        }
        .onChange(of: selectedConversation) { _, _ in
            checkIfSelfIsActiveTab()
        }
    }
    
    private func checkIfSelfIsActiveTab() {
        withAnimation(.easeOut(duration: 0.1)) {
            isActive = selectedConversation == conversation
        }
    }
}
