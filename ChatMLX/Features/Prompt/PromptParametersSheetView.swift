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
        Form {
            Section("Parameters") {
                TemperatureView
                TopPView
                MaxTokenView()
                RepetitionPenaltyView()
                RepetitionContextSizeView()
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
            value: $vm.temperature,
            in: 0 ... 2,
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
    }

    @ViewBuilder
    var TopPView: some View {
        @Bindable var vm = vm
        CompactSlider(
            value: $vm.topP,
            in: 0 ... 1,
            step: 0.1
        ) {
            Text("Top P")
            Spacer()
            Text("\(vm.topP, specifier: "%.1f")")
        }
        .compactSliderSecondaryColor(.blue)
    }

    @ViewBuilder
    func MaxTokenView() -> some View {
        CompactSlider(
            value: Binding {
                CFloat(vm.maxTokens)
            } set: {
                vm.maxTokens = Int($0)
            },
            in: CFloat(1) ... CFloat(4096),
            step: 1
        ) {
            Text("Maximum Length")
            Spacer()
            Text("\(vm.maxTokens)")
        }
        .compactSliderSecondaryColor(.blue)
    }

    @ViewBuilder
    func RepetitionPenaltyView() -> some View {
        @Bindable var vm = vm
        CompactSlider(
            value: $vm.repetitionPenalty,
            in: 1 ... 5,
            step: 0.1
        ) {
            Text("Repetition Penalty")
            Spacer()
            Text("\(vm.repetitionPenalty, specifier: "%.1f")")
        }
        .compactSliderSecondaryColor(.blue)
    }

    @ViewBuilder
    func RepetitionContextSizeView() -> some View {
        CompactSlider(
            value: Binding {
                CFloat(vm.repetitionContextSize)
            } set: {
                vm.repetitionContextSize = Int($0)
            },
            in: CFloat(1) ... CFloat(256),
            step: 1
        ) {
            Text("Repetition Context Size")
            Spacer()
            Text("\(vm.repetitionContextSize)")
        }
        .compactSliderSecondaryColor(.blue)
    }
}
