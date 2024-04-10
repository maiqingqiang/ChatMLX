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

        Form {
            Section("Recommended") {
                ForEach(vm.models.indices, id: \.self) { index in
                    if vm.models[index].recommended {
                        ModelItemView(
                            model: $vm.models[index]
                        )
                    }
                }
            }

            Section("Other") {
                ForEach(vm.models.indices, id: \.self) { index in
                    if !vm.models[index].recommended {
                        ModelItemView(
                            model: $vm.models[index]
                        )
                    }
                }
            }
        }
        .formStyle(.grouped)
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
                Menu {
                    Button("Add Huggingface Model") {
                        // 在这里添加点击"Add Other Model"后的逻辑
                        print("Add Other Model")
                    }
                    Button("Add Local Model") {
                        isPresented = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .symbolRenderingMode(.multicolor)
                }
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
