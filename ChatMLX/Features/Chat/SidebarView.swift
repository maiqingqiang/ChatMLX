//
//  SidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftData
import SwiftUI

struct SidebarView: View {
    @Query private var conversations: [Conversation]
    @Binding var selectedConversation: Conversation?
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewConversationAlert = false
    @State private var newConversationTitle = ""
    
    var sortedConversations: [Conversation] {
        conversations.sorted { $0.updatedAt > $1.updatedAt }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showingNewConversationAlert = true
                }) {
                    Image(systemName: "plus.app")
                }
                .buttonStyle(.plain)
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            .alert("新建对话", isPresented: $showingNewConversationAlert) {
                TextField("对话标题", text: $newConversationTitle)
                Button("取消", role: .cancel) {
                    newConversationTitle = ""
                }
                Button("创建") {
                    createNewConversation()
                }
            } message: {
                Text("请输入新对话的标题")
            }
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sortedConversations) { conversation in
                        SidebarItem(
                            conversation: conversation,
                            selectedConversation: $selectedConversation
                        )
                    }
                }
            }
        }
        .background(.black.opacity(0.4))
    }

    private func createNewConversation() {
        guard !newConversationTitle.isEmpty else { return }
        let newConversation = Conversation(title: newConversationTitle, model: "gpt-3.5-turbo")
        modelContext.insert(newConversation)
        newConversationTitle = ""
        selectedConversation = newConversation
    }
}

// #Preview {
//    SidebarView()
// }
