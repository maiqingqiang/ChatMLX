//
//  GeneralView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/18.
//

import CompactSlider
import CoreData
import Defaults
import Luminare
import SwiftUI

struct GeneralView: View {
    @Default(.backgroundBlurRadius) var blurRadius
    @Default(.backgroundColor) var backgroundColor
    @Default(.language) var language
    @Default(.gpuCacheLimit) var gpuCacheLimit

    @Environment(\.managedObjectContext) private var viewContext

    @Environment(SettingsViewModel.self) private var vm
    @Environment(ConversationViewModel.self) private var conversationViewModel

    @Environment(LLMRunner.self) var runner

    let maxRAM = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)

    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Language") {
                HStack {
                    Text("Language")
                    Spacer()
                    Picker(
                        "Language",
                        selection: $language
                    ) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .labelsHidden()
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                .padding(8)
            }

            LuminareSection("Window Appearance") {
                HStack {
                    Text("Blur")
                    Spacer()
                    CompactSlider(value: $blurRadius, in: 0 ... 100) {
                        Text("\(Int(blurRadius))")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200)
                    .compactSliderSecondaryColor(.white)
                }
                .padding(5)

                HStack {
                    Text("Color")
                    Spacer()
                    ColorPicker("", selection: $backgroundColor)
                        .labelsHidden()
                }
                .padding(5)
            }

            LuminareSection("System Settings") {
                HStack {
                    Text("GPU Cache Limit")
                    Spacer()
                    CompactSlider(
                        value: Binding(
                            get: { Double(gpuCacheLimit) },
                            set: { gpuCacheLimit = Int32($0) }
                        ), in: 0 ... Double(maxRAM), step: 128
                    ) {
                        Text("\(Int(gpuCacheLimit))MB")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200)
                    .compactSliderSecondaryColor(.white)
                    .onChange(of: gpuCacheLimit) { oldValue, newValue in
                        if oldValue != newValue {
                            runner.loadState = .idle
                        }
                    }
                }
                .padding(5)

                Button("Clear All Conversations", action: clearAllConversations)
                    .frame(height: 35)
                Button("Reset All Settings", action: resetAllSettings)
                    .frame(height: 35)
            }
            .buttonStyle(LuminareDestructiveButtonStyle())

            Spacer()
        }

        .ultramanNavigationTitle("General")
        .padding()
    }

    private func resetAllSettings() {
        Defaults.reset(.defaultModel)
        Defaults.reset(.language)
        Defaults.reset(.backgroundBlurRadius)
        Defaults.reset(.backgroundColor)
        Defaults.reset(.huggingFaceEndpoint)
        Defaults.reset(.customHuggingFaceEndpoints)
        Defaults.reset(.useCustomHuggingFaceEndpoint)
        Defaults.reset(.huggingFaceToken)
        Defaults.reset(.defaultTitle)
        Defaults.reset(.defaultTemperature)
        Defaults.reset(.defaultTopP)
        Defaults.reset(.defaultUseMaxLength)
        Defaults.reset(.defaultMaxLength)
        Defaults.reset(.defaultRepetitionContextSize)
        Defaults.reset(.defaultMaxMessagesLimit)
        Defaults.reset(.defaultUseMaxMessagesLimit)
        Defaults.reset(.defaultRepetitionPenalty)
        Defaults.reset(.defaultUseRepetitionPenalty)
        Defaults.reset(.defaultUseSystemPrompt)
        Defaults.reset(.defaultSystemPrompt)
        Defaults.reset(.gpuCacheLimit)
    }

    private func clearAllConversations() {
        do {
            let persistenceController = PersistenceController.shared

            let messageObjectIds = try persistenceController.clear("Message")
            let conversationObjectIds = try persistenceController.clear("Conversation")

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [
                    NSDeletedObjectsKey: messageObjectIds + conversationObjectIds
                ],
                into: [persistenceController.container.viewContext]
            )

            conversationViewModel.selectedConversation = nil
        } catch {
            vm.throwError(error, title: "Clear All Conversations Failed")
        }
    }
}

#Preview {
    GeneralView()
}
