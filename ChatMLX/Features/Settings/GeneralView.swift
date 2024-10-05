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
                LabeledContent("Language") {
                    Picker(
                        "Language",
                        selection: $language
                    ) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                .padding(8)
            }

            LuminareSection("Window Appearance") {
                LabeledContent("Blur") {
                    CompactSlider(value: $blurRadius, in: 0 ... 100) {
                        Text("\(Int(blurRadius))")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200)
                    .compactSliderSecondaryColor(.white)
                }
                .padding(5)

                LabeledContent("Color") {
                    ColorPicker("", selection: $backgroundColor)
                }
                .padding(5)
            }

            LuminareSection("System Settings") {
                Button("Clear All Conversations", action: clearAllConversations)
                    .frame(height: 35)
                Button("Reset All Settings", action: resetAllSettings)
                    .frame(height: 35)
            }
            .buttonStyle(LuminareDestructiveButtonStyle())

            Spacer()
        }
        .labeledContentStyle(.horizontal)
        .ultramanNavigationTitle("General")
        .padding()
        .labelsHidden()
    }

    private func resetAllSettings() {
        Defaults.removeAll()
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
