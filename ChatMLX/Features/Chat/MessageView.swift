//
//  MessageView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import MarkdownUI
import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if message.role == .assistant {
                    Image("logo", bundle: .main)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.3), radius: 1)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .padding(5)
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.3), radius: 1)
                }

                Text(message.role.rawValue)
                    .font(.title3.weight(.semibold))
            }
            .foregroundColor(.primary)

            Markdown(message.content)
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    List {
        MessageView(message: Message(role: .user, content: "hi！"))
            .listRowSeparator(.hidden)
        MessageView(message: Message(role: .assistant, content: "hi！"))
            .listRowSeparator(.hidden)
    }
}
