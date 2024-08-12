//
//  DownloadTaskView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadTaskView: View {
    @Bindable var task: DownloadTask
    @Environment(DownloadManagerView.ViewModel.self) private var viewModel

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(task.repoId)
                        .font(.headline)
                        .lineLimit(1)
                        .help(task.repoId)
                    
                    Spacer()
                    
                    Text("\(Int(task.progress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(width: 40, alignment: .trailing)
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
                    .frame(width: 32, height: 32)
            } else {
                Button(action: {
                    task.stop()
                    viewModel.tasks.removeAll(where: { $0.id == task.id })
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.7))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.borderless)
                .disabled(task.isCompleted)
            }
        }
        .padding()
        .background(.black.opacity(0.3))
        .listRowSeparator(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black, radius: 2)
    }
}
