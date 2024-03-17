//
//  DetailView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct DetailView: View {
    @Environment(ChatViewModel.self) private var vm

    @State private var isPresented: Bool = false

    @Environment(\.dismiss)
    var dismiss

    let messageEnd: String = "End"

    var body: some View {
        @Bindable var vm = vm
        VStack(spacing: 0) {
            if let conversation = vm.selectedConversation, !conversation.messages.isEmpty {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack {
                            LazyVStack(alignment: .leading) {
                                ForEach(
                                    conversation.messages.sorted(by: { $0.createdAt < $1.createdAt }
                                    )
                                ) { message in
                                    MessageView(message: message)
                                }
                            }

                            LabelledDivider(label: messageEnd)
                                .frame(height: 50)
                                .id(messageEnd)
                        }
                        .padding()
                    }

                    .background(.white)
                    .onChange(of: conversation.messages) {
                        scrollToBottom(scrollViewProxy)
                    }
                    .onAppear {
                        scrollToBottom(scrollViewProxy)
                    }
                }
                .onAppear {
                    vm.loadFromModelDirectory()
                }
                .task {
                    try! await vm.load()
                }

            } else {
                WelcomeView()
            }

            InputBarView()
        }.toolbar {
            ToolbarItem {
                Button("Setting Conversation", systemImage: "slider.horizontal.3") {
                    isPresented = true
                }
                .help("Setting Conversation")
                .symbolRenderingMode(.multicolor)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                VStack(alignment: .leading) {
                    if let conversation = vm.selectedConversation {
                        Text(
                            conversation.name.isEmpty ? "New Chat" : conversation.name
                        )
                        .font(.title2.bold())
                        Text(conversation.model)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("ChatMLX")
                            .font(.title2.bold())
                        Text(
                            UserDefaults.standard.string(forKey: Preferences.activeModel.rawValue)
                                ?? ""
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("")
        .sheet(
            isPresented: $isPresented,
            content: {
                ParametersView()
            }
        )
    }

    func scrollToBottom(_ scrollViewProxy: ScrollViewProxy) {
        scrollViewProxy.scrollTo(messageEnd, anchor: .bottom)
    }
}

// #Preview {
//    var conversation = Conversation(
//        model: "",
//        messages: [
//            Message(role: .user, content: "hi！"),
//            Message(role: .assistant, content: "hi！"),
//        ]
//    )
//    return DetailView()
//        .environment(ChatViewModel(
//            selectedConversation: conversation,
//            conversations: [conversation]
//        ))
// }
