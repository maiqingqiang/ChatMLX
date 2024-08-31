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
    let message: Message
    @Binding var displayStyle: DisplayStyle
    @State private var showToast = false
    var onDelete: () -> Void
    var onRegenerate: () -> Void

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
        .padding(.vertical, 8)
        .toast(isPresenting: $showToast, duration: 1.5, offsetY: 30) {
            AlertToast(displayMode: .hud, type: .complete(.green), title: "Copied")
        }
    }

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
                        .textSelection(.enabled)

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

                    Button(action: onRegenerate) {
                        Image(systemName: "arrow.clockwise")
                            .help("Regenerate")
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

                Button(action: copyText) { 
                    Image(systemName: "doc.on.doc")
                         .help("Copy")
                }

                Button(action: onDelete) {
                    Image(systemName: "trash")
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
