//
//  DefaultChatView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/27.
//

import CompactSlider
import Defaults
import Luminare
import SwiftUI

struct DefaultConversationView: View {
    @Default(.defaultTitle) var defaultTitle
    @Default(.defaultModel) var defaultModel
    @Default(.defaultTemperature) var defaultTemperature
    @Default(.defaultTopP) var defaultTopP
    @Default(.defaultMaxLength) var defaultMaxLength
    @Default(.defaultRepetitionContextSize) var defaultRepetitionContextSize
    @Default(.defaultMaxMessagesLimit) var defaultMaxMessagesLimit
    @Default(.defaultUseMaxMessagesLimit) var defaultUseMaxMessagesLimit
    @Default(.defaultRepetitionPenalty) var defaultRepetitionPenalty
    @Default(.defaultUseRepetitionPenalty) var defaultUseRepetitionPenalty
    @Default(.defaultUseMaxLength) var defaultUseMaxLength
    @Default(.defaultUseSystemPrompt) var defaultUseSystemPrompt
    @Default(.defaultSystemPrompt) var defaultSystemPrompt

    @State private var localModels: [LocalModel] = []

    @Environment(SettingsViewModel.self) var vm

    private let padding: CGFloat = 6

    var body: some View {
        ScrollView {
            VStack {
                LuminareSection("Title") {
                    UltramanTextField(
                        $defaultTitle,
                        placeholder: Text("Default conversation title")
                    )
                    .frame(height: 25)
                }

                LuminareSection("Model Settings") {
                    HStack {
                        Text("Model")
                        Spacer()
                        Picker(
                            selection: $defaultModel,
                            label: Image(systemName: "brain")
                        ) {
                            if !localModels.isEmpty {
                                Text("Not selected").tag("")
                                ForEach(localModels, id: \.id) { model in
                                    Text(model.name).tag(model.origin)
                                }
                            }
                        }
                        .labelsHidden()
                        .buttonStyle(.borderless)
                        .foregroundStyle(.white)
                        .tint(.white)
                    }
                    .padding(padding)

                    HStack {
                        Text("Temperature")
                        Spacer()
                        CompactSlider(
                            value: $defaultTemperature, in: 0 ... 2, step: 0.01
                        ) {
                            Text("\(defaultTemperature, specifier: "%.2f")")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }
                    .padding(padding)

                    HStack {
                        Text("Top P")
                        Spacer()
                        CompactSlider(
                            value: $defaultTopP, in: 0 ... 1, step: 0.01
                        ) {
                            Text("\(defaultTopP, specifier: "%.2f")")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }
                    .padding(padding)

                    HStack {
                        Text("Use Max Length")
                        Spacer()
                        Toggle("", isOn: $defaultUseMaxLength)
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if defaultUseMaxLength {
                        HStack {
                            Text("Max Length")
                            Spacer()
                            CompactSlider(
                                value: Binding(
                                    get: { Double(defaultMaxLength) },
                                    set: { defaultMaxLength = Int64($0) }
                                ), in: 0 ... 8192, step: 1
                            ) {
                                Text("\(defaultMaxLength)")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                        .padding(padding)
                    }

                    HStack {
                        Text("Repetition Context Size")
                        Spacer()
                        CompactSlider(
                            value: Binding(
                                get: { Double(defaultRepetitionContextSize) },
                                set: { defaultRepetitionContextSize = Int32($0) }
                            ), in: 0 ... 100, step: 1
                        ) {
                            Text("\(defaultRepetitionContextSize)")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }
                    .padding(padding)

                    HStack {
                        Text("Use Repetition Penalty")
                        Spacer()
                        Toggle("", isOn: $defaultUseRepetitionPenalty)
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if defaultUseRepetitionPenalty {
                        HStack {
                            Text("Repetition Penalty")
                            Spacer()
                            CompactSlider(
                                value: $defaultRepetitionPenalty, in: 1 ... 2,
                                step: 0.01
                            ) {
                                Text(
                                    "\(defaultRepetitionPenalty, specifier: "%.2f")"
                                )
                                .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                        .padding(padding)
                    }
                }
                .compactSliderSecondaryColor(.white)

                LuminareSection("Message Control") {
                    HStack {
                        Text("Use Max Messages Limit")
                        Spacer()
                        Toggle("", isOn: $defaultUseMaxMessagesLimit)
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if defaultUseMaxMessagesLimit {
                        HStack {
                            Text("Max Messages Limit")
                            Spacer()
                            CompactSlider(
                                value: Binding(
                                    get: { Double(defaultMaxMessagesLimit) },
                                    set: { defaultMaxMessagesLimit = Int32($0) }
                                ), in: 1 ... 50, step: 1
                            ) {
                                Text("\(defaultMaxMessagesLimit)")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                        .padding(padding)
                    }
                }
                .compactSliderSecondaryColor(.white)

                LuminareSection("System Prompt") {
                    HStack {
                        Text("Use System Prompt")
                        Spacer()
                        Toggle("", isOn: $defaultUseSystemPrompt)
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if defaultUseSystemPrompt {
                        UltramanTextEditor(
                            text: $defaultSystemPrompt,
                            placeholder: "System prompt",
                            onSubmit: {}
                        )
                        .frame(height: 100)
                        .padding(padding)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .onAppear(perform: loadModels)
        .ultramanNavigationTitle("Default Conversation")
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

            if !models.contains(where: { $0.origin == defaultModel }) {
                defaultModel = ""
            }

            Task { @MainActor in
                localModels = models
            }
        } catch {
            vm.throwError(error, title: "Load Models Failed")
        }
    }
}
