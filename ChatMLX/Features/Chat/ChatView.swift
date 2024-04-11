//
//  ChatView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import MarkdownUI
import SwiftData
import SwiftUI
import AlertToast

struct ChatView: View {
    @Environment(ChatViewModel.self) private var vm
    @State private var text: String = ""

    var body: some View {
        @Bindable var vm = vm
        if let conversation = vm.conversation() {
            VStack(spacing: 0) {
                HStack {
                    Picker("", selection: $vm.selectedDisplayStyle) {
                        ForEach(DisplayStyle.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 150)
                    
                    Spacer()

                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                }
                .padding()
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(conversation.messages) { message in
                            MessageView(message: message)
                        }
                    }
                }
                .padding([.horizontal])
                
                Divider()
                
                ZStack(alignment: .bottom) {
                    TextEditorWithPlaceholder(text: $text, placeholder: "Message ChatMLX...")
                        
                    HStack(spacing: 16) {
                        Spacer()
                        Button("Clear") {
                            text = ""
                        }
                        .buttonStyle(.borderless)
                        .disabled(text.isEmpty)
                    
                        Button(action: {}, label: {
                            Label("Send", systemImage: "paperplane")
                        })
                        .buttonStyle(BlackButtonStyle())
                        .controlSize(.large)
                        .buttonBorderShape(.automatic)
                        .tint(.black)
                        .disabled(text.isEmpty)
                    }
                    .padding()
                }
                
                .frame(height: 150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .ignoresSafeArea()
            .toast(isPresenting: $vm.showToast) {
                AlertToast(type: .complete(.green), title: vm.toastTitle)
            }
        } else {
            Text("Not Found")
        }
    }
}

#Preview {
    ChatView()
}
