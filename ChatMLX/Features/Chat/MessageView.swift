//
//  MessageView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import MarkdownUI
import SwiftData
import SwiftUI

struct MessageView: View {
    @Environment(ChatViewModel.self) private var vm

    let message: Message

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Group {
                    if message.role == .assistant {
                        Image("logo", bundle: .main)
                            .resizable()
                    }
                    else {
                        Image(systemName: "person.fill")
                            .resizable()
                    }
                }
                .padding(5)
                .frame(width: 26, height: 26)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .shadow(color: .gray.opacity(0.3), radius: 2)

                Text(message.role.rawValue.capitalized)
                    .font(.title2)
                    .bold()

                Spacer()
                if message.role == .assistant {
                    Button(
                        action: {
                            vm.copyToClipboard(message.content)
                        },
                        label: {
                            Image(systemName: "doc.on.doc")
                        }
                    )
                    .buttonStyle(.borderless)
                    .padding(.horizontal)
                    .help("Copy to clipboard")
                }
            }
            .foregroundColor(.primary)

            Markdown(message.content)
                .markdownTheme(.gitHub)
                .textSelection(.enabled)
                .font(.body)
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    let schema = Schema([
        Conversation.self,
        Message.self,
    ])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: true
    )

    let modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])

    return List {
        MessageView(message: Message(role: .user, content: "User"))
        MessageView(message: Message(role: .assistant, content: "Assistant"))
    }
    .environment(ChatViewModel(modelContext: modelContainer.mainContext))
}
