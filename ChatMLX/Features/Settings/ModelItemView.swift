//
//  File.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import Foundation
import os
import SwiftUI

struct ModelItemView: View {
    @Environment(SettingsViewModel.self) private var vm

    @AppStorage(Preferences.activeModel.rawValue) private var activeModel: String = ""

    @State private var isPresented: Bool = false

    @Binding var model: MLXModel

    @State var hovering: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if case .downloading(let progress, let totalFileCount, let completedFileCount) = model.state {
                    Rectangle()
                        .foregroundColor(.blue.opacity(0.3))
                        .frame(width: geometry.size.width * CGFloat(progress))
                        .animation(.snappy, value: progress)
                }
                HStack {
                    switch model.state {
                    case .unavailable, .availabled:
                        Text(model.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .textSelection(.enabled)
                        if model.name == activeModel {
                            Text("default")
                                .padding(5)
                                .font(.footnote)
                                .foregroundColor(.green)
                                .background(.green.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    case .downloading(let progress, let totalFileCount, let completedFileCount):
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)

                        VStack(alignment: .leading) {
                            Text(model.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .textSelection(.enabled)

                            HStack {
                                Text("\(completedFileCount)/\(totalFileCount)")
                                Text(progress, format: .percent)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                    control
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 50)
        .background(.selection.opacity(0.2))
        .listRowSeparator(.hidden)
        .onHover(perform: { hovering in
            withAnimation {
                self.hovering = hovering
            }
        })
    }

    var control: some View {
        HStack {
            switch model.state {
            case .unavailable:
                Button(
                    action: {
                        Task {
                            await vm.download(model: model)
                        }

                    },
                    label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.blue)
                    })
            case .availabled:
                Button(
                    action: {
                        activeModel = model.name
                    },
                    label: {
                        Image(systemName: model.name == activeModel ? "checkmark.circle" : "circle")
                    }).foregroundColor(model.name == activeModel ? .green : .gray)

                Button(
                    action: {
                        vm.remove(model: model)
                    },
                    label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    })
            default:
                EmptyView()
            }
        }
        .buttonStyle(.plain)
        .fontWeight(.bold)
    }
}

// #Preview {
//    @State var model = Model(name: "mlx-community/starcoder2-7b-4bit")
//
//    return List {
//        ModelItemView(model: Binding(get: { Model(name: "mlx-community/starcoder2-7b-4bit") }, set: { _ in }))
//
//        ModelItemView(model: Binding(get: { Model(name: "mlx-community/starcoder2-7b-4bit", isDownloading: true, totalFileCount: 6, completedFileCount: 1) }, set: { _ in }))
//
//        ModelItemView(model: Binding(get: { Model(name: "mlx-community/starcoder2-7b-4bit", isExists: true) }, set: { _ in }))
//    }
//    .environment(ModelsSettingsViewModel(store: Store()))
//    .environmentObject(Store())
// }
