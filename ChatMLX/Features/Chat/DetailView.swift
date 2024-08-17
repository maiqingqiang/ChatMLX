//
//  DetailView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//
import Defaults
import Luminare
import MLXLLM
import SwiftData
import SwiftUI

struct DetailView: View {
    @State private var llm = LLMEvaluator()

    let conversation: Conversation
    @State private var newMessage = ""
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isInputFocused: Bool

    @State private var showRightSidebar = false

    @Namespace var bottomId

    @State private var localModels: [LocalModel] = []

    var sortedMessages: [Message] {
        conversation.messages.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                if llm.running {
                    ProgressView()
                        .frame(maxHeight: 20)
                }
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
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Menu {
                            ForEach(localModels, id: \.id) {
                                model in
                                Button(
                                    action: {
                                        let configuration =
                                            MLXLLM.ModelConfiguration(
                                                directory: model.url,
                                                overrideTokenizer:
                                                "PreTrainedTokenizer"
                                            )
                                        conversation.model = "\(model.group)/\(model.name)"

                                        llm.changeModel(to: configuration)
                                    }) {
                                        HStack {
                                            Text(model.name)
                                            if llm.modelConfiguration.name
                                                == model.name
                                            {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                            }
                        } label: {
                            Image(systemName: "brain")
                        }
                        .menuStyle(BorderlessButtonMenuStyle())
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                    .padding(10)
                    ZStack(alignment: .bottom) {
                        UltramanTextEditor(
                            text: $newMessage,
                            placeholder: "Type your message…",
                            onSubmit: sendMessage
                        )
                        .padding(.horizontal, 5)

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
                            .disabled(
                                newMessage.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty)
                        }
                        .padding()
                    }
                    .frame(maxHeight: 150)
                    .ultramanNavigationTitle(conversation.title)
                    .ultramanToolbarItem(alignment: .trailing) {
                        Button(action: {
                            print("Leading action")
                        }) {
                            Image(systemName: "arrow.left")
                        }
                    }
                }
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
        .task {
            _ = try? await llm.load()
        }
        .onAppear(perform: loadModels)
    }

    private func sendMessage() {
        let trimmedMessage = newMessage.trimmingCharacters(
            in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        conversation.addMessage(
            Message(
                role: .user,
                content: trimmedMessage
            )
        )
        newMessage = ""
        isInputFocused = false

        Task {
            await llm.generate(conversation: conversation)
            conversation.addMessage(
                Message(
                    role: .assistant,
                    content: llm.output
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

    private func loadModels() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask
        )[0]
        let modelsURL = documentsURL.appendingPathComponent(
            "huggingface/models")

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: modelsURL, includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
            var models: [LocalModel] = []

            for groupURL in contents {
                if groupURL.hasDirectoryPath {
                    let modelContents = try fileManager.contentsOfDirectory(
                        at: groupURL, includingPropertiesForKeys: nil,
                        options: [.skipsHiddenFiles]
                    )

                    for modelURL in modelContents {
                        if modelURL.hasDirectoryPath {
                            models.append(
                                LocalModel(
                                    group: groupURL.lastPathComponent,
                                    name: modelURL.lastPathComponent,
                                    url: modelURL
                                )
                            )
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                localModels = models
            }
        } catch {
            print("加载模型时出错: \(error)")
        }
    }
}
