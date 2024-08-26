//
//  MessageBubbleView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import MarkdownUI
import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    @Binding var displayStyle: DisplayStyle
    @State private var showCopiedAlert = false

    var body: some View {
        HStack {
            if message.role == .assistant {
                assistantMessageView
            } else {
                Spacer()
                userMessageView
            }
        }
        .padding(.vertical, 8)
        .alert(isPresented: $showCopiedAlert) {
            Alert(
                title: Text("已复制"), message: nil,
                dismissButton: .default(Text("确定"))
            )
        }
    }

    private var assistantMessageView: some View {
        HStack(alignment: .top, spacing: 12) {
            ChatAvatarView(role: .assistant)

            VStack(alignment: .leading) {
                if displayStyle == .markdown {
                    Markdown(MarkdownContent(message.content))
                        .markdownCodeSyntaxHighlighter(
                            .splash(theme: .sunset(withFont: .init(size: 16)))
                        )
                        .markdownTextStyle {
                            ForegroundColor(.white)
                        }
                        .markdownTheme(.customGitHub)
                        .textSelection(.enabled)

                } else {
                    Text(message.content)
                }
                HStack {
                    Button(action: {
                        showCopiedAlert = true
                    }) {
                        Image(systemName: "doc.on.doc")
                    }

                    Button(action: {}) {
                        Image(systemName: "arrow.clockwise")
                    }

                    Text(formatDate(message.timestamp))
                        .font(.caption)

                    if message.role == .assistant, !message.isComplete {
                        ProgressView()
                            .controlSize(.small)
                            .colorInvert()
                            .brightness(1)
                            .padding(.leading, 5)
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }

    private var userMessageView: some View {
        VStack(alignment: .trailing) {
            Text(message.content)
                .padding(10)
                .background(Color.black.opacity(0.1618))
                .foregroundColor(.white)
                .cornerRadius(8)

            HStack {
                Text(formatDate(message.timestamp))
                    .font(.caption)

                Button(action: {
                    showCopiedAlert = true
                }) {
                    Image(systemName: "doc.on.doc")
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.white.opacity(0.8))
            .padding(.top, 4)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

// #Preview {
//    VStack {
//        MessageBubbleView(message: Message(role: .user, content: "Hi!"))
//        MessageBubbleView(
//            message: Message(
//                role: .assistant, content: "Hello! How can I help you today?"))
//    }
// }