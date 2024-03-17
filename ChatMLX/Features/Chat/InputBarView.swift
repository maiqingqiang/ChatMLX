//
//  InputBarView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct InputBarView: View {
    @Environment(ChatViewModel.self) private var vm
    @FocusState private var isFocused: Bool

    var body: some View {
        @Bindable var vm = vm

        HStack {
            TextField("Message ChatMLX...", text: $vm.content)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .font(.title3)

            Button(
                action: vm.submit,
                label: {
                    Image(systemName: "arrow.up")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            )
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.return, modifiers: [])
            .disabled(vm.content.isEmpty)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(nsColor: .controlBackgroundColor))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(nsColor: .separatorColor))
                }
        )
        .padding(12)
    }
}

//#Preview {
//    InputBarView()
//        .environment(ChatViewModel())
//}
