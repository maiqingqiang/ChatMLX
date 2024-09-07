//
//  DownloadManagerView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadManagerView: View {
    @Environment(SettingsView.ViewModel.self) private var settingsViewModel

    @State private var repoId: String = ""
    @State var showingAlert = false

    var body: some View {

        List {
            ForEach(settingsViewModel.tasks) { task in
                DownloadTaskView(task: task)
            }
        }
        .onChange(of: showingAlert) { _, _ in
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollContentBackground(.hidden)
        .onAppear()
        .ultramanNavigationTitle("Download Manager")
        .ultramanToolbar(alignment: .trailing) {
            Button(action: show) {
                Image(systemName: "plus")
            }
            .buttonStyle(.plain)
        }
        .alert("New Task", isPresented: $showingAlert) {
            TextField(
                "Hugging Face Repo Id", text: $repoId,
                prompt: Text("mlx-community/OpenELM-3B"))
            Button("Cancel", role: .cancel) {
                repoId = ""
            }
            Button(action: addTask) {
                Text("Done")
            }
        } message: {
            Text("Please enter Hugging Face Repo ID")
        }
    }

    private func show() {
        showingAlert = true
    }

    private func addTask() {
        let task = DownloadTask(repoId)
        task.start()
        settingsViewModel.tasks.append(task)
    }
}
