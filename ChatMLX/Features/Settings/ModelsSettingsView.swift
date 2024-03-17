//
//  ModelsSettingsView.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import Foundation
import SwiftUI

struct ModelsSettingsView: View {
    @Environment(SettingsViewModel.self) private var vm
    @State private var model: String = ""

    @State var isPresented: Bool = false

    var body: some View {
        @Bindable var vm = vm

        SettingsForm {
            Section("Recommended") {
                ForEach(vm.models.indices, id: \.self) { index in
                    if vm.models[index].isRecommended {
                        ModelItemView(
                            model: $vm.models[index]
                        )
                    }
                }
            }

            Section("Other") {
                ForEach(vm.models.indices, id: \.self) { index in
                    if !vm.models[index].isRecommended {
                        ModelItemView(
                            model: $vm.models[index]
                        )
                    }
                }
            }
        }
        .alert("Add Other Model", isPresented: $isPresented) {
            TextField(
                "HuggingFace Model Repo",
                text: $model,
                prompt: Text("mlx-community/quantized-gemma-7b-it")
            )

            Button("Confirm") {
                vm.add(model: model)
            }
            .disabled(model.isEmpty)

            Button("Cancel") {
                model = ""
            }
        }
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    isPresented = true
                }) {
                    Image(systemName: "plus")
                        .symbolRenderingMode(.multicolor)
                }
                .buttonStyle(.accessoryBar)
            }
        })
    }
}

#Preview {
    VStack {
        ModelsSettingsView()
    }
    .padding()
}
