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
import SwiftData
import SwiftUI

struct ConversationDetailView: View {
    @Environment(LLMRunner.self) var runner
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var conversation: Conversation
    @Environment(\.managedObjectContext) private var viewContext

    @State private var newMessage = ""
    @FocusState private var isInputFocused: Bool
    @Environment(ConversationViewModel.self) private
    var conversationViewModel
    @State private var showRightSidebar = false
    @State private var showInfoPopover = false
    @Namespace var bottomId
    @State private var localModels: [LocalModel] = []
    @State private var displayStyle: DisplayStyle = .markdown
    @State private var isEditorFullScreen = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: AlertToast.AlertType = .regular

    @State private var loading = true

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
                        )
                    }
                }
                .padding()
                .id(bottomId)
            }
            .onChange(
                of: conversation.messages.last,
                {
                    proxy.scrollTo(bottomId, anchor: .bottom)
                }
            )
            .onAppear {
                proxy.scrollTo(bottomId, anchor: .bottom)
            }
        }
    }

    @MainActor
    @ViewBuilder
    private func EditorToolbar() -> some View {
        HStack {
            Button {
                withAnimation {
                    if displayStyle == .markdown {
                        displayStyle = .plain
                    } else {
                        displayStyle = .markdown
                    }
                }
            } label: {
                if displayStyle == .markdown {
                    Image("doc-plaintext")
                } else {
                    Image("markdown")
                }
            }

            Button(action: {
//                conversation.clearMessages()
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
                        Text(formatTimeInterval(conversation.promptTime))
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
                        Text(formatTimeInterval(conversation.generateTime))
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
        Task {
            do {
                await runner.generate(
                    message: trimmedMessage,
                    conversation: conversation,
                    in: viewContext
                )

                try PersistenceController.shared.save()
            } catch {
                conversationViewModel.throwError(error: error)
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
            showToastMessage(
                "loadModels failed: \(error.localizedDescription)",
                type: .error(Color.red)
            )
        }
    }

    private func formatTimeInterval(_ interval: TimeInterval?) -> String {
        guard interval != nil else {
            return ""
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval!) ?? ""
    }

    private func showToastMessage(_ message: String, type: AlertToast.AlertType) {
        toastMessage = message
        toastType = type
        showToast = true
    }
}
