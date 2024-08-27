//
//  HuggingFaceView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/27.
//

import Defaults
import Luminare
import SwiftUI

struct HuggingFaceView: View {
    @Default(.huggingFaceEndpoint) var endpoint
    @Default(.customHuggingFaceEndpoints) var customEndpoints

    @Default(.huggingFaceToken) var token

    @State private var newCustomEndpoint: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Hugging Face Token") {
                HStack {
                    Text("Token")
                    Spacer()
                    UltramanSecureField(
                        Binding(
                            get: { token ?? "" },
                            set: { token = $0.isEmpty ? nil : $0 }
                        ),
                        placeholder: Text("Enter your Hugging Face token"),
                        alignment: .trailing
                    )
                    .frame(height: 25)
                }
                .padding(5)
            }

            LuminareSection("Hugging Face Endpoint") {
                HStack {
                    Text("Endpoint")
                    Spacer()
                    Picker("", selection: $endpoint) {
                        Text("https://huggingface.co").tag(
                            "https://huggingface.co")
                        Text("https://hf-mirror.com").tag(
                            "https://hf-mirror.com")
                        ForEach(customEndpoints, id: \.self) { customEndpoint in
                            Text(customEndpoint).tag(customEndpoint)
                        }
                    }
                    .labelsHidden()
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                .padding(8)

                HStack {
                    Text("Custom Endpoint")
                    Spacer()
                    UltramanTextField(
                        $newCustomEndpoint,
                        placeholder: Text("Custom Hugging Face Endpoint"),
                        alignment: .trailing
                    )
                    .frame(height: 25)
                    .onSubmit {
                        addCustomEndpoint()
                    }
                }
                .padding(5)

                if !customEndpoints.isEmpty {
                    List {
                        ForEach(customEndpoints, id: \.self) { customEndpoint in
                            HStack {
                                Text(customEndpoint)
                                Spacer()

                                Button {
                                    removeCustomEndpoint(customEndpoint)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }

            Spacer()
        }
        .ultramanNavigationTitle("Hugging Face")
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("提示"), message: Text(alertMessage),
                dismissButton: .default(Text("确定"))
            )
        }
    }

    private func addCustomEndpoint() {
        guard !newCustomEndpoint.isEmpty else {
            alertMessage = "请输入有效的源地址"
            showingAlert = true
            return
        }

        guard URL(string: newCustomEndpoint) != nil else {
            alertMessage = "请输入有效的 URL"
            showingAlert = true
            return
        }

        if !customEndpoints.contains(newCustomEndpoint) {
            customEndpoints.append(newCustomEndpoint)
            endpoint = newCustomEndpoint
            newCustomEndpoint = ""
        } else {
            alertMessage = "该源地址已存在"
            showingAlert = true
        }
    }

    private func removeCustomEndpoint(_ endpoint: String) {
        customEndpoints.removeAll { $0 == endpoint }
        if self.endpoint == endpoint {
            self.endpoint = "https://huggingface.co"
        }
    }
}
