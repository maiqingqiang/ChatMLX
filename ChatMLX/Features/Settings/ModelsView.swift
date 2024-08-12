//
//  ModelsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import Observation
import SwiftUI

struct RepoDownloadView: View {
    @State private var viewModel = RepoDownloadViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repos) { repo in
                    RepoDownloadRow(repo: repo, viewModel: viewModel)
                }
            }
            .navigationTitle("模型下载")
        }
    }
}

struct RepoDownloadRow: View {
    @Bindable var repo: RepoInfo
    @Bindable var viewModel: RepoDownloadViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name)
                .font(.headline)

            ProgressView(value: repo.progress)
                .progressViewStyle(LinearProgressViewStyle())

            Text("进度: \(Int(repo.progress * 100))%")
                .font(.caption)

            HStack {
                Button(repo.isDownloading ? "停止" : "下载") {
                    if repo.isDownloading {
                        viewModel.stopDownload(for: repo.id)
                    } else {
                        viewModel.startDownload(for: repo.id)
                    }
                }
                .disabled(repo.isCompleted)

                if repo.isCompleted {
                    Text("已完成")
                        .foregroundColor(.green)
                }
            }

            if let error = repo.error {
                Text("错误: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}

@Observable
class RepoDownloadViewModel {
    var repos: [RepoInfo]

    init() {
        self.repos = [
            RepoInfo(id: "mlx-community/Qwen1.5-14B-Chat-4bit", name: "Qwen1.5-14B-Chat-4bit"),
            RepoInfo(id: "mlx-community/Qwen1.5-1.8B-Chat-4bit", name: "Qwen1.5-1.8B-Chat-4bit"),
            RepoInfo(id: "mlx-community/Qwen1.5-0.5B-Chat-4bit", name: "Qwen1.5-0.5B-Chat-4bit"),
            RepoInfo(id: "mlx-community/quantized-gemma-7b-it", name: "quantized-gemma-7b-it")
        ]
    }

    func startDownload(for repoId: String) {
        guard let index = repos.firstIndex(where: { $0.id == repoId }) else { return }
        repos[index].isDownloading = true
        repos[index].error = nil
        repos[index].progress = 0

        Task { @MainActor in
            do {
                let repo = Hub.Repo(id: repoId)
                try await repos[index].hub.snapshot(from: repo, matching: ["*.safetensors"]) { progressInfo in
                    self.repos[index].progress = progressInfo.fractionCompleted
                    print("\(self.repos[index].id) -> progress -> \(progressInfo.fractionCompleted)")
                }
                self.repos[index].isDownloading = false
                self.repos[index].isCompleted = true
                self.repos[index].progress = 1.0
            } catch {
                self.repos[index].error = error
                self.repos[index].isDownloading = false
            }
        }
    }

    func stopDownload(for repoId: String) {
        guard let index = repos.firstIndex(where: { $0.id == repoId }) else { return }
        repos[index].hub.cancelCurrentDownload()
        repos[index].isDownloading = false
    }
}

@Observable
class RepoInfo: Identifiable {
    let id: String
    let name: String
    var progress: Double = 0
    var isDownloading = false
    var isCompleted = false
    var error: Error?
    let hub: HubApi

    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.hub = HubApi()
    }
}

struct ModelsView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            RepoDownloadView()
        }
    }
}

#Preview {
    ModelsView()
}
