//
//  ChatSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI
import SwiftUIIntrospect

struct ChatSidebarView: View {
    @Environment(ChatViewModel.self) private var vm
    @State private var showingClearChatDialog = false

    var body: some View {
        @Bindable var vm = vm
        VStack {
            HStack {
                Text("ChatMLX")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
                Button(action: {
                    showingClearChatDialog = true
                }) {
                    Image(systemName: "eraser.line.dashed")
                }
                .buttonStyle(.borderless)

                Button(action: vm.addConversation) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)

            List(selection: $vm.selectedConversationID) {
                ForEach(vm.conversations) { conversation in
                    ChatSidebarItemView(conversation: conversation)
                }
            }
            .listStyle(.plain)
            .introspect(.list, on: .macOS(.v14)) {
                vm.tableViewDelegate.tableView = $0
            }
        }
        .padding(.top)
        .frame(maxHeight: .infinity)
        .background(.white)
        .ignoresSafeArea()
        .confirmationDialog(
            "Are you sure you want to clear all chats?",
            isPresented: $showingClearChatDialog
        ) {
            Button("Clear", role: .destructive, action: vm.clear)
            Button("Cancel", role: .cancel) {}
        }
        .dialogSeverity(.critical)
    }
}
