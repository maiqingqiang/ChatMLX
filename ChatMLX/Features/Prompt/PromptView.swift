//
//  PromptView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import AlertToast
import CompactSlider
import SwiftUI

struct PromptView: View {
    @Environment(PromptViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm
        VSplitView {
            PromptInputView()
            PromptOutputView()
        }
        .padding()
        .background(.white)
        .ignoresSafeArea()
        .sheet(isPresented: $vm.isPresentedParameters) {
            PromptParametersSheetView()
        }
        .toast(isPresenting: $vm.showToast) {
            AlertToast(type: .complete(.green), title: vm.toastTitle)
        }
        .toast(isPresenting: $vm.showErrorToast, duration: 0) {
            AlertToast(type: .error(.red), title: vm.error)
        }
    }
}

#Preview {
    PromptView()
}
