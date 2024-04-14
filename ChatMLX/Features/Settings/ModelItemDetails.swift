//
//  File.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import SwiftUI

struct ModelItemDetails: View {
    @AppStorage(Preferences.defaultModel.rawValue) private var active: String = ""

    @Environment(\.dismiss)
    var dismiss

    @Binding var model: MLXModel

    @State var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            Group {
                Button(
                    action: {
                        active = model.name
                    },
                    label: {
                        Text("Activate")
                    }
                )
                .buttonStyle(.borderedProminent)
                .disabled(active == model.name)
            }
            .padding(.horizontal)

            Form {
                Section("System Prompt") {
                    TextEditor(text: $text)
                        .frame(height: 200)
                }
            }
            .formStyle(.grouped)

            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)

                Button {
                    //                    model.systemPrompt = text
                    dismiss()
                } label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    ModelItemDetails(
        model: Binding(
            get: {
                MLXModel(name: "mlx-community/quantized-gemma-7b-it")
            },
            set: { _ in }
        )
    )
}
