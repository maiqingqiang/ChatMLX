//
//  MessageView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI
import MarkdownUI

struct MessageView: View {
    let message: Message
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Group {
                    if message.role == .assistant {
                        Image("logo", bundle: .main)
                            .resizable()
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                    }
                }
                .padding(5)
                .frame(width: 24, height: 24)
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .gray.opacity(0.3), radius: 1)

                Text(message.role.rawValue)
                    .font(.title3.weight(.semibold))

                Spacer()
                if message.role == .assistant {
                    Button(action: {}, label: {
                        Image(systemName: "doc.on.doc")
                    }).buttonStyle(.borderless)
                }
            }
            .foregroundColor(.primary)

            Markdown(message.content)
        }
        .padding(.bottom, 25)
    }
}

//#Preview {
//    MessageView()
//}
