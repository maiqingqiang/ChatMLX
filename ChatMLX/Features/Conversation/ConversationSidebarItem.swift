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
    @Environment(ConversationViewModel.self) private var vm

    @State private var isActive: Bool = false

    var body: some View {
        Button(action: selectConversation) {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(conversation.title))
                    .font(.headline)

                HStack {
                    Text(conversation.messages.first?.content ?? "")
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer()

                    if !(conversation.isFault || conversation.isDeleted) {
                        Text(conversation.updatedAt.toFormatted())
                            .font(.caption)
                    }
                }
                .foregroundStyle(.white.opacity(0.7))
            }
            .padding(6)
        }
        .buttonStyle(UltramanSidebarButtonStyle(isActive: $isActive))
        .onAppear(perform: updateActiveState)
        .onChange(of: vm.selectedConversation) { _, _ in updateActiveState() }
        .contextMenu {
            Button(role: .destructive, action: deleteConversation) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func selectConversation() {
        vm.selectedConversation = conversation
    }

    private func updateActiveState() {
        withAnimation(.easeOut(duration: 0.1)) {
            isActive = vm.selectedConversation == conversation
        }
    }

    private func deleteConversation() {
        do {
            try PersistenceController.shared.delete(conversation)
        } catch {
            vm.throwError(error, title: "Delete Conversation Failed")
        }
    }
}
