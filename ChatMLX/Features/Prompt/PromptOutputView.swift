//
//  PromptOutputView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import MarkdownUI
import SwiftUI

struct PromptOutputView: View {
    @Environment(PromptViewModel.self) private var vm
    var body: some View {
        @Bindable var vm = vm
        VStack {
            HStack {
                Label("Output", systemImage: "text.bubble")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if vm.running {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Button(action: vm.copyToClipboard, label: {
                    Image(systemName: "doc.on.doc")
                })
                .buttonStyle(.borderless)
                .disabled(vm.output.isEmpty || vm.running)
                .help("Copy to clipboard")
                
                Picker("", selection: $vm.selectedDisplayStyle) {
                    ForEach(DisplayStyle.allCases, id: \.self) { option in
                        Text(option.rawValue.capitalized)
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 150)
            }
            .padding(.top)
            
            ScrollView {
                if vm.selectedDisplayStyle == .markdown {
                    Markdown(vm.output)
                } else {
                    Text(vm.output)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
    }
}

#Preview {
    PromptOutputView()
}
