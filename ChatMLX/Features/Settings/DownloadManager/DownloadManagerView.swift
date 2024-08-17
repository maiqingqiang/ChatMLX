//
//  DownloadManagerView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadManagerView: View {
    @Environment(ViewModel.self) private var viewModel
    @State private var showingNewTask = false
    @State private var repoId = ""

    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
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
            TextField("Hugging Face Repo Id", text: $repoId, prompt: Text("mlx-community/OpenELM-3B"))
            Button("Cancel", role: .cancel) {
                repoId = ""
            }
            Button("Done") {
                let newTask = DownloadTask(repoId)
                newTask.start()
                viewModel.tasks.append(newTask)
            }
        } message: {
            Text("Please enter Hugging Face Repo ID")
        }
    }

    private func addNewTask() {
        let newTask = DownloadTask("mlx-community/Qwen1.5-0.5B-Chat-4bit")
        newTask.start()
        viewModel.tasks.append(newTask)
    }
}

extension DownloadManagerView {
    @Observable
    class ViewModel {
        var tasks: [DownloadTask] = []
    }
}

#Preview {
    DownloadManagerView()
}
