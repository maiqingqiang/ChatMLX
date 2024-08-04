//
//  DetailView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import Luminare
import SwiftData
import SwiftUI

struct DetailView: View {
    let conversation: Conversation
    @State private var newMessage = ""
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isInputFocused: Bool

    var sortedMessages: [Message] {
        conversation.messages.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 2)
            ScrollView {
                LazyVStack {
                    ForEach(sortedMessages) { message in
                        MessageBubbleView(message: message)
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField("", text: $newMessage)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .focused($isInputFocused)
                    .frame(minHeight: 40)
                    .placeholder("请输入文本", when: newMessage.isEmpty)

//                LuminareTextField($newMessage, placeHolder: "输入消息...")
//                    .foregroundColor(.white)
//                    .focused($isInputFocused)
//                    .frame(minHeight: 40)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .buttonStyle(.plain)
                .padding(.horizontal, 10)
            }
        }
    }

    private func sendMessage() {
        let trimmedMessage = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        conversation.addMessage(
            Message(
                role: .user,
                content: trimmedMessage
            )
        )
        newMessage = ""
        isInputFocused = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            conversation.addMessage(
                Message(
                    role: .assistant,
                    content: "这是AI的回复"
                )
            )
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = conversation.messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
