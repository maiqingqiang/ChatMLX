//
//  SettingView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/4.
//

import os
import SwiftUI

struct SettingView: View {
    @State var viewModel: SettingViewModel = .init()
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "SettingViewModel")

    @State var selecting = false

    var body: some View {
        VStack {
            Button("Select Model") {
                viewModel.selecting = true
            }
            .fileImporter(
                isPresented: $viewModel.selecting,
                allowedContentTypes: [.folder]
            ) { result in
                switch result {
                case .success(let url):
                    viewModel.modelDirectory = url
                case .failure(let error):
                    logger.error("\(error.localizedDescription)")
                }
            }
            
            if let model = viewModel.modelDirectory {
                Text(model.relativeString)
            } else {
                Text("No LLM Folder Selected")
            }

//            Section {
//                SecureField(
//                    "",
//                    text: $viewModel.huggingFaceToken,
//                    prompt: Text("Enter your HuggingFace token...")
//                )
//            }

//            Section {
//
//            }
        }
        .frame(width: 180)
        .padding()
    }
}

#Preview {
    SettingView()
}
