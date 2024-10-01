//
//  ConversationSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftData
import SwiftUI

struct ConversationSidebarView: View {
    @Query(Conversation.all, animation: .bouncy) private var conversations: [Conversation]
    @Binding var selectedConversation: Conversation?
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewConversationAlert = false
    @State private var newConversationTitle = ""
    @State private var showingClearConfirmation = false

    let padding: CGFloat = 8

    var filteredConversations: [Conversation] {
        if keyword.isEmpty {
            conversations
        } else {
            conversations.filter { conversation in
                conversation.title.lowercased().contains(keyword.lowercased())
                    || conversation.messages.contains { message in
                        message.content.lowercased().contains(
                            keyword.lowercased())
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
                    createConversation()
                }) {
                    Image(systemName: "plus")
                }

                SettingsLink {
                    Image(systemName: "gear")
                }
            }
            .frame(height: 50)
            .padding(.horizontal, padding)
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
                UltramanTextField(
                    $keyword, placeholder: Text("Search Conversation...")
                )
                .frame(height: 25)
            }.padding(.horizontal, padding)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredConversations) { conversation in
                        ConversationSidebarItem(
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

    private func createConversation() {
        let conversation = Conversation()
        modelContext.insert(conversation)
        selectedConversation = conversation
    }
}
