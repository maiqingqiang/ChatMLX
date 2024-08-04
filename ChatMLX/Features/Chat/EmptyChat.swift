//
//  EmptyChat.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftUI

struct EmptyChat: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Chat", systemImage: "tray.fill")
                .foregroundColor(.white)
        } description: {
            Text("New mails you receive will appear here.")
                .foregroundColor(.white)
            Button(
                action: {},
                label: {
                    HStack {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.white)
                        Text("New Chat")
                    }
                    .foregroundColor(.white)
                }
            ).buttonStyle(LuminareCompactButtonStyle())
                .fixedSize()
        }
    }
}
