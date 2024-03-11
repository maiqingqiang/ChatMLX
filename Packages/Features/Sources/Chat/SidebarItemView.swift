//
//  SidebarItemView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct SidebarItemView: View {
    @Environment(ChatViewModel.self) private var vm

    var conversation: Conversation

    @State var hovering: Bool = false

    var body: some View {
        HStack {
            Text(conversation.messages.last?.content.prefix(20) ?? "New Chat")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()

            if hovering {
                Button(action: {
                    vm.remove(conversation: conversation)
                }, label: {
                    Image(systemName: "trash")
                })
                .buttonStyle(.plain)
                .fontWeight(.bold)
                .foregroundColor(.red)
            }
        }
        .onHover(perform: { hovering in
            withAnimation(.easeIn) {
                self.hovering = hovering
            }
        })
        .padding(8)
    }
}

 #Preview {
    SidebarItemView(conversation: Conversation(model: ""))
         .environment(ChatViewModel())
 }
