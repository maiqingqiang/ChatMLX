//
//  ChatDetailView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import AlertToast
import MarkdownUI
import SwiftData
import SwiftUI

struct ChatDetailView: View {
    @Environment(ChatViewModel.self) private var vm
    @Environment(AppStroe.self) private var store
    @Namespace var bottomId

    var body: some View {
        @Bindable var vm = vm
        if let conversation = vm.conversation() {
            VStack(spacing: 0) {
                HStack {
                    Text(conversation.name.isEmpty ? "New Chat" : conversation.name)
                        .font(.title)
                        .bold()

                    Picker("", selection: $vm.selectedDisplayStyle) {
                        ForEach(DisplayStyle.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 150)

                    Spacer()

                    Group {
                        Color.green
                        //                        switch vm.loadState {
                        //                        case .idle:
                        //                            Color.red
                        //                        case .loaded:
                        //                            Color.green
                        //                        }
                    }
                    .frame(width: 12, height: 12)
                    .clipShape(Circle())
                    .help("Model Load State")

                    Menu(conversation.selectedModel) {
                        ForEach(store.models, id: \.self) { model in
                            Button(model) {
                                conversation.selectedModel = model
                            }
                        }
                    }
                    .menuStyle(.borderlessButton)
                    .padding(5)
                    .frame(width: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.horizontal)

                    Button(
                        action: {},
                        label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    )
                    .buttonStyle(.borderless)
                }
                .padding()

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(conversation.sortedMessages) { message in
                                MessageView(message: message)
                            }
                        }
                        .padding([.horizontal])
                        .id(bottomId)
                    }
                    .onChange(
                        of: conversation.sortedMessages.last?.content,
                        {
                            proxy.scrollTo(bottomId, anchor: .bottom)
                        }
                    )
                    .onAppear {
                        proxy.scrollTo(bottomId, anchor: .bottom)
                    }
                }

                Divider()

                ZStack(alignment: .bottom) {
                    TextEditorWithPlaceholder(text: $vm.content, placeholder: "Message ChatMLX...")

                    HStack(spacing: 16) {
                        Spacer()
                        Button("Clear") {
                            vm.content = ""
                        }
                        .buttonStyle(.borderless)
                        .disabled(vm.content.isEmpty)

                        Button(
                            action: {
                                Task {
                                    await vm.submit(conversation)
                                }
                            },
                            label: {
                                Label("Send", systemImage: "paperplane")
                            }
                        )
                        .buttonStyle(BlackButtonStyle())
                        .controlSize(.large)
                        .buttonBorderShape(.automatic)
                        .tint(.black)
                        .disabled(vm.content.isEmpty)
                    }
                    .padding()
                }

                .frame(height: 150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .ignoresSafeArea()
            .toast(isPresenting: $vm.showToast) {
                AlertToast(type: .complete(.green), title: vm.toastTitle)
            }
        }
        else {
            VStack(spacing: 10) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                Text("No Chat")
                    .font(.title)
                    .bold()
                Text("Please select a new chat")
                    .font(.headline)
            }
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ChatDetailView()
}
