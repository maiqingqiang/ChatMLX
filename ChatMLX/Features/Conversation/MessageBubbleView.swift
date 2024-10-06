//
//  MessageBubbleView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import AlertToast
import MarkdownUI
import SwiftUI

struct MessageBubbleView: View {
    @ObservedObject var message: Message
    @Binding var displayStyle: DisplayStyle
    @State private var showToast = false

    @Environment(LLMRunner.self) var runner
    @Environment(ConversationViewModel.self) var vm

    @Environment(\.managedObjectContext) private var viewContext

    private func copyText() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message.content, forType: .string)
        showToast = true
    }

    var body: some View {
        HStack {
            if message.role == .assistant {
                assistantMessageView
            } else {
                Spacer()
                userMessageView
            }
        }
        .textSelection(.enabled)
        .padding(.vertical, 8)
        .toast(isPresenting: $showToast, duration: 1.5, offsetY: 30) {
            AlertToast(displayMode: .hud, type: .complete(.green), title: "Copied")
        }
    }

    @MainActor
    @ViewBuilder
    private var assistantMessageView: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .black.opacity(0.25), radius: 5, x: -1, y: 5)

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
                } else {
                    Text(message.content)
                }

                if let error = message.error, !error.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.yellow)
                        Text(error)
                    }
                    .padding(5)
                    .background(.red.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }

                HStack {
                    Button(action: copyText) {
                        Image(systemName: "doc.on.doc")
                            .help("Copy")
                    }

                    Button(action: regenerate) {
                        Image(systemName: "arrow.clockwise")
                            .help("Regenerate")
                    }

                    Text(message.updatedAt.toTimeFormatted())
                        .font(.caption)

                    if message.role == .assistant, message.inferring {
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

    @MainActor
    @ViewBuilder
    private var userMessageView: some View {
        VStack(alignment: .trailing) {
            Text(message.content)
                .padding(10)
                .background(Color.black.opacity(0.1618))
                .foregroundColor(.white)
                .cornerRadius(8)

            HStack {
                Text(message.updatedAt.toTimeFormatted())
                    .font(.caption)

                Button(action: copyText) {
                    Image(systemName: "doc.on.doc")
                        .help("Copy")
                }

                Button(action: delete) {
                    Image(systemName: "trash")
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.white.opacity(0.8))
            .padding(.top, 4)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func delete() {
        guard message.role == .user else { return }
        let conversation = message.conversation
        let messages = conversation.messages
        if let index = messages.firstIndex(of: message) {
            for message in messages[index...] {
                viewContext.delete(message)
            }
        }

        Task(priority: .background) {
            do {
                try await viewContext.perform {
                    if viewContext.hasChanges {
                        try viewContext.save()
                    }
                }
            } catch {
                vm.throwError(error, title: "Delete Message Failed")
            }
        }
    }

    private func regenerate() {
        guard message.role == .assistant else { return }

        Task {
            let conversation = message.conversation
            let messages = conversation.messages
            if let index = messages.firstIndex(of: message) {
                for message in messages[index...] {
                    viewContext.delete(message)
                }
            }

            await MainActor.run {
                runner.generate(conversation: conversation, in: viewContext, completion: nil)
            }
        }
    }
}
