//
//  DetailView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct DetailView: View {
    @Environment(ChatViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm
        VStack(spacing: 0) {
            if let conversation = vm.selectedConversation {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(conversation.messages) { message in
                                MessageView(message: message)
                            }
                        }
                        .padding()
                    }
                    .background(.white)
                    .onChange(of: conversation.messages) { _, newValue in
                        proxy.scrollTo(newValue, anchor: .bottom)
                    }
                }
            } else {
                WelcomeView()
            }

            InputBarView()
        }
    }
}

#Preview {
    var conversation = Conversation(
        model: "",
        messages: [
            Message(content: "hi！", role: .user),
        ]
    )
    return DetailView()
        .environment(ChatViewModel(
            selectedConversation: conversation,
            conversations: [conversation]
        ))
}
