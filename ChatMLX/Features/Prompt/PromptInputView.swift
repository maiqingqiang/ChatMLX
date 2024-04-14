//
//  PromptInputView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI

struct PromptInputView: View {
    @Environment(PromptViewModel.self) private var vm
    @Environment(AppStroe.self) private var store

    var body: some View {
        @Bindable var vm = vm
        VStack {
            HStack {
                Label("Prompt", systemImage: "sparkles")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Group {
                    switch vm.loadState {
                    case .idle:
                        Color.red
                    case .loaded:
                        Color.green
                    }
                }
                .frame(width: 12, height: 12)
                .clipShape(Circle())
                .help("Model Load State")

                Menu(vm.selectedModel) {
                    ForEach(store.models, id: \.self) { model in
                        Button(model) {
                            vm.switchModel(model: model)
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
                    action: vm.openPromptParameters,
                    label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                )
                .buttonStyle(.borderless)
                .font(.title2)
            }

            TextEditorWithPlaceholder(
                text: $vm.text,
                placeholder:
                    "Start typing a prompt for the AI models, then hit Run Playground to see the results."
            )

            HStack(spacing: 16) {
                Spacer()

                Button("Clear", action: vm.clear)
                    .buttonStyle(.borderless)
                    .disabled(vm.text.isEmpty)

                Button {
                    if vm.running {
                        vm.stop()
                    }
                    else {
                        Task {
                            await vm.run()
                        }
                    }
                } label: {
                    if vm.running {
                        Label("Stop Generation", systemImage: "stop")
                    }
                    else {
                        Label("Run Playground", systemImage: "paperplane")
                    }
                }
                .buttonStyle(BlackButtonStyle())
                .controlSize(.large)
                .buttonBorderShape(.automatic)
                .tint(.black)
                .disabled(vm.text.isEmpty)
            }
            .padding(.bottom)
        }
    }
}

// #Preview {
//    PromptHeaderView()
// }
