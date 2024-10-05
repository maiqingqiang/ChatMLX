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
    @Environment(ConversationViewModel.self) private var vm
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Conversation.updatedAt, ascending: false)],
        animation: .default
    )
    private var conversations: FetchedResults<Conversation>

    @Binding var selectedConversation: Conversation?

    @State private var keyword = ""

    let padding: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            headerView()
            logoView()
            searchField()
            conversationList()
        }
        .background(.black.opacity(0.4))
    }

    @MainActor
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Spacer()
            Button(action: vm.createConversation) {
                Image(systemName: "plus")
            }
            SettingsLink {
                Image(systemName: "gear")
            }
        }
        .frame(height: 50)
        .padding(.horizontal, padding)
        .buttonStyle(.plain)
    }

    @MainActor
    @ViewBuilder
    private func logoView() -> some View {
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
    }

    @MainActor
    @ViewBuilder
    private func searchField() -> some View {
        LuminareSection {
            UltramanTextField(
                $keyword,
                placeholder: Text("Search Conversation..."),
                onSubmit: updateSearchPredicate
            )
            .frame(height: 25)
        }
        .padding(.horizontal, padding)
    }

    @MainActor
    @ViewBuilder
    private func conversationList() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(conversations) { conversation in
                    ConversationSidebarItem(conversation: conversation)
                }
            }
        }
        .padding(.top, 6)
    }

    private func updateSearchPredicate() {
        conversations.nsPredicate = keyword.isEmpty ? nil : NSPredicate(
            format: "title CONTAINS [cd] %@ OR ANY messages.content CONTAINS [cd] %@",
            keyword, keyword
        )
    }
}
