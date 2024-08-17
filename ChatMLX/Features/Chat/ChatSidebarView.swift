//
//  SidebarView.swift
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

    var sortedConversations: [Conversation] {
        conversations.sorted { $0.updatedAt > $1.updatedAt }
    }

    @State private var keyword = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    createNewConversation()
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 50)
            .padding(.horizontal, 20)

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
                    ForEach(sortedConversations) { conversation in
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
}

// #Preview {
//    SidebarView()
// }
