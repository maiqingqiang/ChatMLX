//
//  DownloadManagerView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadManagerView: View {
    @Environment(SettingsView.ViewModel.self) private var settingsViewModel
    @State private var showingNewTask = false
    @State private var repoId = ""

    var body: some View {
        List {
            ForEach(settingsViewModel.tasks) { task in
                DownloadTaskView(task: task)
            }
        }
        .ultramanNavigationTitle("Download Manager")
        .ultramanToolbarItem(alignment: .trailing) {
            Button {
                showingNewTask = true
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless)
        }
        .scrollContentBackground(.hidden)
        .alert("New Task", isPresented: $showingNewTask) {
            TextField(
                "Hugging Face Repo Id", text: $repoId,
                prompt: Text("mlx-community/OpenELM-3B"))
            Button("Cancel", role: .cancel) {
                repoId = ""
            }
            Button("Done") {
                let task = DownloadTask(repoId)
                task.start()
                settingsViewModel.tasks.append(task)
            }
        } message: {
            Text("Please enter Hugging Face Repo ID")
        }
    }
}

#Preview {
    DownloadManagerView()
}
