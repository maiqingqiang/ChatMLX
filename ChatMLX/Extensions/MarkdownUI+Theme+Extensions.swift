//
//  MarkdownUI+Theme+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/18.
//
import MarkdownUI
import SwiftUI

extension MarkdownUI.Theme {
    static let customGitHub = Theme.gitHub.text {
        ForegroundColor(.white)
        BackgroundColor(.clear)
    }
    .code {
        FontFamilyVariant(.monospaced)
        FontSize(.em(0.94))
        BackgroundColor(.clear)
    }
    .codeBlock { configuration in
        VStack(spacing: 0) {
            HStack {
                Text(configuration.language ?? "plain text")
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()

                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(configuration.content, forType: .string)
                } label: {
                    Image(systemName: "clipboard")
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.black.opacity(0.2))

            Divider()
            ScrollView(.horizontal) {
                configuration.label
                    .fixedSize(horizontal: false, vertical: true)
                    .relativeLineSpacing(.em(0.225))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                    }
                    .padding(16)
            }
            .background(.black.opacity(0.1))
            .markdownMargin(top: 0, bottom: 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
