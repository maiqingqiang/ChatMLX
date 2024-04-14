//
//  ChatSidebarItemView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/13.
//

import SwiftUI

struct ChatSidebarItemView: View {
    @Environment(ChatViewModel.self) private var vm
    
    let conversation: Conversation
    
    @State var isEditing: Bool = false
    
    @State var name: String = ""
    
    var body: some View {
        VStack(alignment: .leading,spacing: 8) {
            HStack {
                Text(conversation.name.isEmpty ? "New Chat" : conversation.name)
                    .foregroundColor(.black)
                    .bold()
               
                Spacer()
                Text(conversation.createdAt, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(conversation.sortedMessages.first?.content ?? "")
                .font(.body)
                .foregroundColor(.gray)
        }
        .lineLimit(1)
        .padding(.vertical, 6)
        .contextMenu {
            Button(action: {
                name = conversation.name
                isEditing = true
            }) {
                Label("Rename", systemImage: "square.and.pencil")
            }
            Divider()
            Button(action: {
                vm.removeConversation(conversation: conversation)
            }) {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}
