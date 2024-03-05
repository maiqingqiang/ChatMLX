//
//  ContentView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/2/28.
//

import MarkdownUI
import os
import SwiftUI

struct ChatView: View {
    @State var viewModel: ChatViewModel = .init()
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "ChatView")
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationSplitView {
            VStack {
                historyView

                Button("Select Model") {
                    viewModel.selecting = true
                }
                .fileImporter(
                    isPresented: $viewModel.selecting,
                    allowedContentTypes: [.folder]
                ) { result in
                    switch result {
                    case .success(let url):
                        viewModel.modelDirectory = url
                    case .failure(let error):
                        logger.error("\(error.localizedDescription)")
                    }
                }

                if let model = viewModel.modelDirectory {
                    Text(model.lastPathComponent)
                } else {
                    Text("No Selected")
                }
            }
            .frame(width: 180)
            .padding()
        } detail: {
            VStack(spacing: 0) {
                conversationView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)

                controlView
            }
        }
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    private var historyView: some View {
        List(selection: $viewModel.selectedChatID) {
            ForEach(viewModel.histories) { chat in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(chat.messages.first?.content.prefix(20) ?? "New Chat")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .padding(8)
                .contextMenu {
                    Button("Configure") {}
                    Divider()
                    Button("Delete Chat") {
                        viewModel.delete(chat)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        .toolbar {
            ToolbarItem {
                Button(action: viewModel.add) {
                    Label("Add Chat", systemImage: "plus")
                }
            }
        }
    }

    @ViewBuilder
    private var conversationView: some View {
        let messages = viewModel.histories.first(where: { $0.id == viewModel.selectedChatID })?.messages ?? []

        if messages.isEmpty {
            VStack(spacing: 0) {
                Image(nsImage: NSImage(resource: ImageResource(name: "logo", bundle: .main)))
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("How can I help you today?")
                    .font(.title)
                    .fontWeight(.medium)
            }
        } else {
            List(messages) { message in
                MessageView(message: message)
                    .listRowSeparator(.hidden)
            }
        }
    }

    @ViewBuilder
    private var controlView: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Message ChatMLX...", text: $viewModel.content)
                    .focused($isFocused)
                    .textFieldStyle(.plain)
                    .font(.title3)

                Button(action: viewModel.submit, label: {
                    Image(systemName: "arrow.up")
                        .fontWeight(.bold)
                        .padding(3)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                })
                .buttonStyle(.borderless)
                .keyboardShortcut(.return, modifiers: [])
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(nsColor: .separatorColor))
                    }
            )
            .padding(12)
        }
        .background(.white)
    }
}

#Preview {
    ChatView()
}
