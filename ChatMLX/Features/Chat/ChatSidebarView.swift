//
//  ChatSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI

struct ChatSidebarView: View {
    @Environment(ChatViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm
        VStack {
            HStack {
                Text("ChatMLX")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus").resizable()
                        .frame(width: 16, height: 16)
                }.buttonStyle(SidebarButtonStyle())
            }
            .padding(.horizontal)

            List(selection: $vm.selectedConversationID) {
                ForEach(vm.conversations) { conversation in
                    Item(conversation)
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
        .frame(maxHeight: .infinity)
        .background(.white)
        .ignoresSafeArea()
    }

    @ViewBuilder
    func Item(_ conversation: Conversation) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(conversation.name)
                    .bold()
                Spacer()
                Text(conversation.createdAt, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(conversation.name)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }
}

// #Preview {
//    ChatSidebarView()
// }
