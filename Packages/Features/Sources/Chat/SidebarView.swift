//
//  SidebarView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct SidebarView: View {
    @Environment(ChatViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm

        List(
            $vm.conversations,
            id: \.self,
            editActions: [.delete, .move],
            selection: $vm.selectedConversation
        ) { $conversation in
            SidebarItemView(conversation: conversation)
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    vm.add()
                }) {
                    Label("Add Chat", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    SidebarView()
}
