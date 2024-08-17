//
//  ChatSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftData
import SwiftUI

struct ChatSidebarView: View {
    @Query private var conversations: [Conversation]
    @Binding var selectedConversation: Conversation?
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewConversationAlert = false
    @State private var newConversationTitle = ""
    @State private var showingClearConfirmation = false

    var sortedConversations: [Conversation] {
        conversations.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var filteredConversations: [Conversation] {
        if keyword.isEmpty {
            return sortedConversations
        } else {
            return sortedConversations.filter { conversation in
                conversation.title.lowercased().contains(keyword.lowercased()) ||
                conversation.messages.contains { message in
                    message.content.lowercased().contains(keyword.lowercased())
                }
            }
        }
    }

    @State private var keyword = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    showingClearConfirmation = true
                }) {
                    Image("clear")
                }.confirmationDialog(
                    "Confirm Clear All Conversations",
                    isPresented: $showingClearConfirmation
                ) {
                    Button("Clear", role: .destructive) {
                        clearAllConversations()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text(
                        "This action will delete all conversation records and cannot be undone."
                    )
                }

                Button(action: {
                    createNewConversation()
                }) {
                    Image(systemName: "plus")
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            .buttonStyle(.plain)

            HStack {
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .shadow(radius: 5)
                Text("ChatMLX")
                    .font(.title)
                    .fontWeight(.bold)
            }

            LuminareSection {
                UltramanTextField($keyword, placeholder: Text("Search Chat..."))
                    .frame(height: 25)
            }.padding(.horizontal, 6)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredConversations) { conversation in
                        ChatSidebarItem(
                            conversation: conversation,
                            selectedConversation: $selectedConversation
                        )
                    }
                }
            }
            .padding(.top, 6)
        }
        .background(.black.opacity(0.4))
    }

    private func createNewConversation() {
        let newConversation = Conversation()
        modelContext.insert(newConversation)
        selectedConversation = newConversation
    }

    private func clearAllConversations() {
        for conversation in conversations {
            modelContext.delete(conversation)
        }
        selectedConversation = nil
    }
}
