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

    @State private var showRightSidebar = false
    
    @Namespace var bottomId

    var sortedMessages: [Message] {
        conversation.messages.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(sortedMessages) { message in
                                MessageBubbleView(message: message)
                            }
                        }
                        .padding()
                        .id(bottomId)
                    }
                    .onChange(
                        of: sortedMessages.last,
                        {
                            proxy.scrollTo(bottomId, anchor: .bottom)
                        }
                    )
                    .onAppear {
                        proxy.scrollTo(bottomId, anchor: .bottom)
                    }
                }

                Divider()

//                HStack {

                ZStack(alignment: .bottom) {
                    TextEditorWithPlaceholder(text: $newMessage, placeholder: "Message ChatMLX...")

                    HStack(spacing: 16) {
                        Spacer()
                        Button("Clear") {
                            newMessage = ""
                        }
                        .buttonStyle(.borderless)
                        .disabled(newMessage.isEmpty)

                        Button {
                            sendMessage()
                        } label: {
                            Label("Send", systemImage: "paperplane")
                        }
                        .buttonStyle(LuminareCompactButtonStyle())
                        .fixedSize()
                        .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding()
                }
                .frame(maxHeight: 150)

//                    TextEditor(text: $newMessage)
//                        .textEditorStyle(.plain)
//                        .foregroundColor(.white)
//                        .focused($isInputFocused)
//                        .placeholder("请输入文本", when: newMessage.isEmpty,alignment: .topLeading)
//                        .padding(10)
//                        .frame(height: 200)

//                    TextField("", text: $newMessage)
//                        .textFieldStyle(.plain)
//                        .foregroundColor(.white)
//                        .focused($isInputFocused)
//                        .frame(minHeight: 40)
//                        .placeholder("请输入文本", when: newMessage.isEmpty)
//                        .padding(.horizontal,10)

                //                LuminareTextField($newMessage, placeHolder: "输入消息...")
                //                    .foregroundColor(.white)
                //                    .focused($isInputFocused)
                //                    .frame(minHeight: 40)

//                    Button(action: sendMessage) {
//                        Image(systemName: "paperplane.fill")
//                    }
//                    .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//                    .buttonStyle(.plain)
//                    .padding(.horizontal, 10)
//
//                    Button(action: {
                ////                        withAnimation {
//                            showRightSidebar.toggle()
                ////                        }
//                    }) {
//                        Image(systemName: showRightSidebar ? "sidebar.right" : "sidebar.left")
//                    }
//                }
            }
        }
        .sheet(isPresented: $showRightSidebar) {
            RightSidebarView(
                temperature: Binding(
                    get: { conversation.temperature },
                    set: { conversation.temperature = $0 }
                ),
                topK: Binding(
                    get: { Double(conversation.topK) },
                    set: { conversation.topK = Int($0) }
                ),
                maxLength: Binding(
                    get: { Double(conversation.maxLength) },
                    set: { conversation.maxLength = Int($0) }
                )
            )
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
