//
//  DownloadTaskView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadTaskView: View {
    @Bindable var task: DownloadTask
    @Environment(SettingsViewModel.self) private var settingsViewModel

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(task.repoId.deletingPrefix("mlx-community/"))
                        .font(.headline)
                        .lineLimit(1)
                        .help(task.repoId)

                    Spacer()

                    Text("\(task.progress * 100, specifier: "%.2f")%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(width: 50, alignment: .trailing)
                }

                HStack {
                    Spacer()

                    Text("\(task.completedUnitCount) / \(task.totalUnitCount)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                ProgressView(value: task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 4)
            }

            Spacer()

            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                if task.isDownloading {
                    Button(action: {
                        task.stop()
                    }) {
                        Image(systemName: "pause.circle")
                            .foregroundColor(.yellow)
                    }
                } else {
                    HStack {
                        Button(action: {
                            task.start()
                        }) {
                            Image(systemName: "play.circle")
                                .foregroundColor(.green)
                        }

                        Button(action: {
                            settingsViewModel.tasks.removeAll(where: {
                                $0.id == task.id
                            })
                        }) {
                            Image(systemName: "trash")
                                .renderingMode(.original)
                        }
                    }
                }
            }
        }
        .imageScale(.large)
        .buttonStyle(.plain)
        .padding()
        .background(.black.opacity(0.3))
        .listRowSeparator(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black, radius: 2)
    }
}
