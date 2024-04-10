//
//  PromptParametersSheetView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import CompactSlider
import SwiftUI

struct PromptParametersSheetView: View {
    @Environment(PromptViewModel.self) private var vm
    @Environment(\.dismiss)
    var dismiss

    var body: some View {
        @Bindable var vm = vm
        Form {
            Section("Parameters") {
                TemperatureView
                TopPView
                MaxTokenView()
            }
        }
        .formStyle(.grouped)
        .frame(width: 500)

        Divider()
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Done")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    @ViewBuilder
    var TemperatureView: some View {
        @Bindable var vm = vm
        CompactSlider(
            value: $vm.temperature, in: 0 ... 2,
            direction: .center
        ) {
            Text("Temperature")
            Spacer()
            Text("\(vm.temperature, specifier: "%.2f")")
        }.compactSliderStyle(
            .prominent(
                lowerColor: .blue,
                upperColor: .red,
                useGradientBackground: true
            )
        )
        .compactSliderSecondaryColor(
            vm.temperature <= 0.5 ? .blue : .red
        )
        .help(
            "Controls randomness: Lowering results in less random completions. As the temperature approaches zero, the model will become deterministic and repetitive."
        )
    }

    @ViewBuilder
    var TopPView: some View {
        @Bindable var vm = vm
        CompactSlider(
            value: $vm.topP, in: 0 ... 1,
            step: 0.1
        ) {
            Text("Top K")
            Spacer()
            Text("\(vm.topP, specifier: "%.1f")")
        }
        .compactSliderSecondaryColor(.blue)
        .help(
            "Sort predicted tokens by probability and discards those below the k-th one. A top-k value of 1 is equivalent to greedy search (select the most probable token)"
        )
    }

    @ViewBuilder
    func MaxTokenView() -> some View {
        @Bindable var vm = vm
        CompactSlider(
            value: Binding {
                CFloat(vm.maxTokens)
            } set: {
                vm.maxTokens = Int($0)
            }, in: CFloat(1) ... CFloat(4096), step: 1
        ) {
            Text("Maximum Length")
            Spacer()
            Text("\(vm.maxTokens)")
        }
        .compactSliderSecondaryColor(.blue)
    }
}

// #Preview {
//    ParametersSheetView()
// }
