//
//  DownloadTask.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import Defaults
import Foundation
import Logging

@Observable
class DownloadTask: Identifiable, Equatable {
    let logger = Logger(label: Bundle.main.bundleIdentifier!)

    static func == (lhs: DownloadTask, rhs: DownloadTask) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    let repoId: String
    var progress: Double = 0
    var isDownloading = false
    var isCompleted = false
    var error: Error?
    var hub: HubApi?
    var totalUnitCount: Int64 = 0
    var completedUnitCount: Int64 = 0

    init(_ repoId: String) {
        self.id = UUID()
        self.repoId = repoId
    }

    func start() {
        self.isDownloading = true
        self.error = nil
        self.progress = 0
        let currentEndpoint = Defaults[.huggingFaceEndpoint]
        self.hub = HubApi(
            downloadBase: FileManager.default.temporaryDirectory, endpoint: currentEndpoint)

        Task { [self] in
            do {
                let repo = Hub.Repo(id: self.repoId)
                let temporaryModelDirectory = try await self.hub!.snapshot(
                    from: repo, matching: ["*.safetensors", "*.json"]
                ) { progress in
                    Task { @MainActor in
                        self.progress = progress.fractionCompleted
                        self.totalUnitCount = progress.totalUnitCount
                        self.completedUnitCount = progress.completedUnitCount
                    }
                }

                self.hub = nil

                try await moveToDocumentsDirectory(from: temporaryModelDirectory)

                await MainActor.run {
                    self.isDownloading = false
                    self.isCompleted = true
                    self.progress = 1.0
                }
            } catch {
                logger.error("DownloadTask Error: \(error.localizedDescription)")
                self.hub = nil
                await MainActor.run {
                    self.error = error
                    self.isDownloading = false
                }
            }
        }
    }

    func stop() {
        if let hub {
            hub.cancelCurrentDownload()
            self.isDownloading = false
            self.hub = nil
        }
    }

    private func moveToDocumentsDirectory(from temporaryModelDirectory: URL) async throws {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let downloadBase = documents.appending(component: "huggingface").appending(path: "models")

        let destinationPath = downloadBase.appendingPathComponent(self.repoId)
        try fileManager.createDirectory(at: destinationPath, withIntermediateDirectories: true)

        if fileManager.fileExists(atPath: destinationPath.path) {
            try fileManager.removeItem(at: destinationPath)
        }

        try fileManager.copyItem(at: temporaryModelDirectory, to: destinationPath)

        logger.info("Model moved to: \(destinationPath.path)")
    }
}
