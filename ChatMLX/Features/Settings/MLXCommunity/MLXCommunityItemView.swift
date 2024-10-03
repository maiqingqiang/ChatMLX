//
//  MLXCommunityItemView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct MLXCommunityItemView: View {
    @Binding var model: RemoteModel
    @Environment(SettingsViewModel.self) var settingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(model.repoId.deletingPrefix("mlx-community/"))
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                Button(action: download) {
                    Image(systemName: "arrow.down.circle")
                }
                .buttonStyle(.borderless)

                Button(action: {
                    if let url = URL(
                        string: "https://huggingface.co/\(model.repoId)")
                    {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Image(systemName: "safari")
                }
                .buttonStyle(.borderless)
            }

            HStack {
                Label("\(model.downloads)", systemImage: "arrow.down.circle")
                    .font(.subheadline)

                Label("\(model.likes)", systemImage: "heart.fill")
                    .font(.subheadline)
                    .foregroundColor(.red.opacity(0.6))

                Spacer()

                if let pipelineTag = model.pipelineTag {
                    Text(pipelineTag)
                        .font(.subheadline)
                        .padding(4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(model.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
        .background(.black.opacity(0.3))
        .listRowSeparator(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black, radius: 2)
    }

    private func download() {
        let task = DownloadTask(model.repoId)
        task.start()

        settingsViewModel.tasks.append(task)
        settingsViewModel.activeTabID = .downloadManager
    }
}
