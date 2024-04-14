//
//  ModelUtility.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import Foundation
import Hub

class ModelUtility {
    static func loadFromModelDirectory() -> [String] {
        let fileManager = FileManager.default
        var models: [String] = []
        do {
            let modelDirectories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appending(component: "huggingface")
                .appending(component: "models")

            let repoDirectories = try fileManager.contentsOfDirectory(
                at: modelDirectories,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )

            for repoDirectory in repoDirectories {
                let modelDirectories = try fileManager.contentsOfDirectory(
                    at: repoDirectory,
                    includingPropertiesForKeys: nil,
                    options: .skipsHiddenFiles
                )

                for modelDirectory in modelDirectories {
                    models.append(
                        "\(repoDirectory.lastPathComponent)/\(modelDirectory.lastPathComponent)"
                    )
                }
            }
        }
        catch {
            print("loadFromModelDirectory error: \(error.localizedDescription)")
        }

        return models
    }

    func download(model: String, progressHandler: @escaping (Progress) -> Void = { _ in })
        async throws
    {
        let repo = Hub.Repo(id: model)
        let hub = HubApi()
        let modelFiles = ["config.json", "*.safetensors"]
        try await hub.snapshot(
            from: repo,
            matching: modelFiles,
            progressHandler: progressHandler
        )
    }
}
