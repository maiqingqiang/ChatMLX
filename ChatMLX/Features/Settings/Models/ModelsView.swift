//
//  ModelsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//
import Defaults
import SwiftUI

struct ModelsView: View {
    @State private var modelGroups: [LocalModelGroup] = []

    var body: some View {
        List {
            ForEach(modelGroups.indices, id: \.self) { groupIndex in
                Section(
                    header: Text(modelGroups[groupIndex].name).font(
                        .title2.bold())
                ) {
                    ForEach(modelGroups[groupIndex].models.indices, id: \.self)
                    { modelIndex in
                        ModelItemView(
                            model: $modelGroups[groupIndex].models[modelIndex])
                    }
                }
            }
        }
        .onAppear(perform: loadModels)
        .scrollContentBackground(.hidden)
        .listStyle(SidebarListStyle())
        .ultramanNavigationTitle("Models")
    }

    private func loadModels() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask)[0]
        let modelsURL = documentsURL.appendingPathComponent(
            "huggingface/models")
        var validModelNames = Set<String>()

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: modelsURL, includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles])
            print("contents \(contents)")
            var groups: [LocalModelGroup] = []

            for groupURL in contents {
                if groupURL.hasDirectoryPath {
                    let groupName = groupURL.lastPathComponent
                    var models: [LocalModel] = []

                    let modelContents = try fileManager.contentsOfDirectory(
                        at: groupURL, includingPropertiesForKeys: nil,
                        options: [.skipsHiddenFiles])

                    for modelURL in modelContents {
                        if modelURL.hasDirectoryPath {
                            let modelName = modelURL.lastPathComponent
                            models.append(
                                LocalModel(
                                    group: groupName,
                                    name: modelName,
                                    url: modelURL
                                )
                            )
                            validModelNames.insert(modelName)
                        }
                    }

                    groups.append(
                        LocalModelGroup(name: groupName, models: models))
                }
            }

            DispatchQueue.main.async {
                modelGroups = groups
            }

            print("groups \(groups)")

            cleanupDefaults(validModelNames: validModelNames)

        } catch {
            print("加载模型时出错: \(error)")
        }
    }

    private func cleanupDefaults(validModelNames: Set<String>) {
        Defaults[.enabledModels] = Defaults[.enabledModels].intersection(
            validModelNames)
        if let defaultModel = Defaults[.defaultModel],
            !validModelNames.contains(defaultModel)
        {
            Defaults[.defaultModel] = nil
        }
    }
}
