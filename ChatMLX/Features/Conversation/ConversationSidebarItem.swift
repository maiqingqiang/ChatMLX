//
//  ConversationSidebarItem.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

struct ConversationSidebarItem: View {
    @ObservedObject var conversation: Conversation

    @Environment(\.managedObjectContext) private var viewContext

    @Binding var selectedConversation: Conversation?

    @State private var isHovering: Bool = false
    @State private var isActive: Bool = false
    @State private var showIndicator: Bool = false

    var body: some View {
        Button {
            selectedConversation = conversation
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(conversation.title))
                    .font(.headline)

                HStack {
                    Text(conversation.messages.first?.content ?? "")
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer()

                    Text(conversation.updatedAt.toFormatted())
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
        .contextMenu {
            Button(role: .destructive, action: deleteConversation) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func checkIfSelfIsActiveTab() {
        withAnimation(.easeOut(duration: 0.1)) {
            isActive = selectedConversation == conversation
        }
    }

    private func deleteConversation() {
        try? PersistenceController.shared.delete(conversation)
    }
}
