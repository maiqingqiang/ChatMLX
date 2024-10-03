//
//  ConversationSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import Luminare
import SwiftUI

struct ConversationSidebarView: View {
    @Environment(ConversationViewModel.self) private var conversationViewModel

    @Binding var selectedConversation: Conversation?

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Conversation.updatedAt, ascending: false)],
        animation: .default
    )
    private var conversations: FetchedResults<Conversation>

    @State private var showingNewConversationAlert = false
    @State private var newConversationTitle = ""
    @State private var showingClearConfirmation = false

    let padding: CGFloat = 8

    @State private var keyword = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: conversationViewModel.createConversation) {
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
                    $keyword, placeholder: Text("Search Conversation..."),
                    onSubmit: updateSearchPredicate
                )

                .frame(height: 25)
            }.padding(.horizontal, padding)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(conversations) { conversation in
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

    private func updateSearchPredicate() {
        if keyword.isEmpty {
            conversations.nsPredicate = nil
        } else {
            conversations.nsPredicate = NSPredicate(
                format: "title CONTAINS [cd] %@ OR ANY messages.content CONTAINS [cd] %@", keyword,
                keyword)
        }
    }
}
