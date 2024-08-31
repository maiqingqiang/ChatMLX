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
    @Default(.useCustomHuggingFaceEndpoint) var useCustomEndpoint

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
                        if useCustomEndpoint {
                            ForEach(customEndpoints, id: \.self) {
                                customEndpoint in
                                Text(customEndpoint).tag(customEndpoint)
                            }
                        }
                        Text("https://huggingface.co").tag(
                            "https://huggingface.co")
                        Text("https://hf-mirror.com").tag(
                            "https://hf-mirror.com")
                    }
                    .labelsHidden()
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                .padding(5)

                HStack {
                    Text("Use Custom Endpoint")
                    Spacer()
                    Toggle("", isOn: $useCustomEndpoint)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                .padding(8)

                if useCustomEndpoint {
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
                            ForEach(customEndpoints, id: \.self) {
                                customEndpoint in
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
            }

            Spacer()
        }
        .ultramanNavigationTitle("Hugging Face")
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Warning"), message: Text(alertMessage),
                dismissButton: .default(Text("Done"))
            )
        }
    }

    private func addCustomEndpoint() {
        guard !newCustomEndpoint.isEmpty else {
            alertMessage = "Please enter a valid endpoint."
            showingAlert = true
            return
        }

        guard URL(string: newCustomEndpoint) != nil else {
            alertMessage = "Please enter a valid endpoint url."
            showingAlert = true
            return
        }

        if !customEndpoints.contains(newCustomEndpoint) {
            customEndpoints.append(newCustomEndpoint)
            endpoint = newCustomEndpoint
            newCustomEndpoint = ""
        } else {
            alertMessage = "The endpoint already exists."
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
