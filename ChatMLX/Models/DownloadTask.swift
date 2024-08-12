//
//  DownloadTask.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import Foundation

@Observable
class DownloadTask: Identifiable,Equatable {
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
        self.hub = HubApi(downloadBase: FileManager.default.temporaryDirectory)

        Task { [self] in
            do {
                let repo = Hub.Repo(id: self.repoId)
                try await self.hub!.snapshot(from: repo, matching: ["*.safetensors"]) { progress in
                    Task { @MainActor in
                        self.progress = progress.fractionCompleted
                        self.totalUnitCount = progress.totalUnitCount
                        self.completedUnitCount = progress.completedUnitCount
                    }
                }

                self.hub = nil

                await MainActor.run {
                    self.isDownloading = false
                    self.isCompleted = true
                    self.progress = 1.0
                }
            } catch {
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
}
