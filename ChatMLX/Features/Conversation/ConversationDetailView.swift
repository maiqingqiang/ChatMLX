//
//  ConversationDetailView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import AlertToast
import Defaults
import Luminare
import MLX
import MLXLLM
import SwiftUI

struct ConversationDetailView: View {
    @ObservedObject var conversation: Conversation

    @Environment(LLMRunner.self) var runner
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ConversationViewModel.self) private var vm

    @State private var newMessage = ""

    @State private var showRightSidebar = false
    @State private var showInfoPopover = false

    @State private var localModels: [LocalModel] = []
    @State private var displayStyle: DisplayStyle = .markdown
    @State private var isEditorFullScreen = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: AlertToast.AlertType = .regular
    @State private var loading = true
    @State private var scrollViewProxy: ScrollViewProxy?

    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                if !isEditorFullScreen {
                    MessageBox()
                    Divider()
                }
                Editor()
            }

            if showRightSidebar {
                Color.black.opacity(0.00001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRightSidebar = false
                        }
                    }

                RightSidebarView(conversation: conversation)
            }
        }
        .onAppear(perform: loadModels)
        .toast(isPresenting: $showToast, duration: 1.5, offsetY: 30) {
            AlertToast(
                displayMode: .hud, type: toastType, title: toastMessage
            )
        }
        .ultramanNavigationTitle(
            LocalizedStringKey(conversation.title)
        )
        .ultramanToolbar(alignment: .trailing) {
            Button(action: {
                withAnimation {
                    showRightSidebar.toggle()
                }

            }) {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(.plain)
        }
    }

    @MainActor
    @ViewBuilder
    private func MessageBox() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(conversation.messages) { message in
                        MessageBubbleView(
                            message: message,
                            displayStyle: $displayStyle
                        ).id(message.id)
                    }
                }
                .padding()
            }
            .onChange(
                of: conversation.messages.last,
                { _, _ in
                    scrollToBottom()
                }
            )
            .onAppear {
                scrollViewProxy = proxy
                scrollToBottom()
            }
        }
    }

    private func scrollToBottom() {
        guard let lastMessageId = conversation.messages.last?.id, let scrollViewProxy else {
            return
        }

        withAnimation {
            scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
        }
    }

    @MainActor
    @ViewBuilder
    private func EditorToolbar() -> some View {
        HStack {
            Button {
                withAnimation {
                    displayStyle = (displayStyle == .markdown) ? .plain : .markdown
                }
            } label: {
                Image(displayStyle == .markdown ? "plaintext" : "markdown")
            }

            Button(action: {
                conversation.messages = []
            }) {
                Image("clear")
            }

            Button {
                withAnimation {
                    isEditorFullScreen.toggle()
                }
            } label: {
                Image(
                    systemName: isEditorFullScreen
                        ? "arrow.down.right.and.arrow.up.left"
                        : "arrow.up.left.and.arrow.down.right")
            }
            .help(isEditorFullScreen ? "Exit Full Screen" : "Enter Full Screen")

            Spacer()

            Button {
                showInfoPopover.toggle()
            } label: {
                if runner.gpuActiveMemory > 0 {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("\(runner.gpuActiveMemory)M")
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(20)
                } else {
                    Image(systemName: "info.circle")
                        .padding(4)
                }
            }
            .font(.subheadline)
            .popover(isPresented: $showInfoPopover) {
                VStack(alignment: .leading) {
                    LabeledContent {
                        Text(conversation.promptTime.formatted())
                    } label: {
                        Text("Prompt Time")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text("\(Int(conversation.promptTokensPerSecond))")
                    } label: {
                        Text("Prompt Tokens/second")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text(conversation.generateTime.formatted())
                    } label: {
                        Text("Generate Time")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text("\(Int(conversation.tokensPerSecond))")
                    } label: {
                        Text("Generate Tokens/second")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(.clear)
            }

            Image(systemName: "circle.fill")
                .controlSize(.mini)
                .foregroundStyle(
                    runner.modelConfiguration?.name == conversation.model
                        ? .green : .red
                )
                .symbolEffect(.variableColor, isActive: runner.running)
                .help("Model State")

            Picker(
                selection: $conversation.model,
                label: Image(systemName: "brain")
            ) {
                if !loading {
                    Text("Not selected").tag("")
                    ForEach(localModels, id: \.id) { model in
                        Text(model.name)
                            .tag(model.origin)
                    }
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.white)
        .tint(.white)
        .frame(height: 35)
        .padding(.horizontal, 10)
    }

    @MainActor
    @ViewBuilder
    private func Editor() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorToolbar()

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
                        if runner.running {
                            Label {
                                Text("Send")
                            } icon: {
                                ProgressView()
                                    .controlSize(.small)
                                    .padding(.trailing, 2)
                                    .colorInvert()
                                    .brightness(1)
                            }
                        } else {
                            Label("Send", systemImage: "paperplane")
                        }
                    }
                    .buttonStyle(LuminareCompactButtonStyle())
                    .fixedSize()
                    .disabled(
                        newMessage.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty || runner.running)
                }
                .padding()
            }
            .frame(maxHeight: isEditorFullScreen ? .infinity : 150)
        }
    }

    private func sendMessage() {
        let trimmedMessage = newMessage.trimmingCharacters(
            in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        if conversation.model.isEmpty {
            showToastMessage("Please select a model", type: .error(Color.red))
            return
        }

        newMessage = ""
        isInputFocused = false

        Message(context: viewContext).user(content: trimmedMessage, conversation: conversation)

        let appleIntelligenceEffectManager = AppleIntelligenceEffectManager.shared
        appleIntelligenceEffectManager.setupEffect()

        runner.generate(conversation: conversation, in: viewContext) {
            Task { @MainActor in
                scrollToBottom()
            }
        } completion: {
            Task { @MainActor in
                appleIntelligenceEffectManager.closeEffect()
                scrollToBottom()
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

            if !models.contains(where: { $0.origin == conversation.model }) {
                conversation.model = ""
            }

            Task { @MainActor in
                localModels = models
                loading = false
            }
        } catch {
            vm.throwError(error, title: "Load Models Failed")
        }
    }

    private func showToastMessage(_ message: String, type: AlertToast.AlertType) {
        toastMessage = message
        toastType = type
        showToast = true
    }
}
