//
//  ParametersView.swift
//
//
//  Created by John Mai on 2024/3/17.
//

import CompactSlider
import SwiftData
import SwiftUI

struct ParametersView: View {
    @Environment(\.dismiss)
    var dismiss

    @Environment(ChatViewModel.self) private var vm

    var body: some View {
        @Bindable var vm = vm
        VStack {
            if let index = vm.conversations.firstIndex(of: vm.selectedConversation!) {
                Form {
                    Section {
                        TextField(
                            "Name", text: $vm.conversations[index].name, prompt: Text("Enter name"))
                    }

                    Section {
                        Picker("Model", selection: $vm.conversations[index].model) {}
                    }

                    Section("Parameters") {
                        CompactSlider(
                            value: $vm.conversations[index].temperature, in: 0 ... 2,
                            direction: .center
                        ) {
                            Text("Temperature")
                            Spacer()
                            Text("\(vm.conversations[index].temperature, specifier: "%.2f")")
                        }.compactSliderStyle(
                            .prominent(
                                lowerColor: .blue,
                                upperColor: .red,
                                useGradientBackground: true
                            )
                        )
                        .compactSliderSecondaryColor(
                            vm.conversations[index].temperature <= 0.5 ? .blue : .red
                        )
                        .help(
                            "Controls randomness: Lowering results in less random completions. As the temperature approaches zero, the model will become deterministic and repetitive."
                        )

                        CompactSlider(
                            value: Binding(
                                get: {
                                    CFloat(vm.conversations[index].topK)
                                }, set: { vm.conversations[index].topK = Int($0) }), in: 1 ... 50,
                            step: 1
                        ) {
                            Text("Top K")
                            Spacer()
                            Text("\(vm.conversations[index].topK)")
                        }
                        .compactSliderSecondaryColor(.blue)
                        .help(
                            "Sort predicted tokens by probability and discards those below the k-th one. A top-k value of 1 is equivalent to greedy search (select the most probable token)"
                        )

                        CompactSlider(
                            value: Binding {
                                CFloat(vm.conversations[index].maxToken)
                            } set: {
                                vm.conversations[index].maxToken = Int($0)
                            }, in: CFloat(1) ... CFloat(4096), step: 1
                        ) {
                            Text("Maximum Length")
                            Spacer()
                            Text("\(vm.conversations[index].maxToken)")
                        }
                        .compactSliderSecondaryColor(.blue)
                        .help(
                            "The maximum number of tokens to generate. Requests can use up to 2,048 tokens shared between prompt and completion. The exact limit varies by model. (One token is roughly 4 characters for normal English text)"
                        )
                    }

                    Section("Prompt") {
                        TextEditor(text: $vm.conversations[index].prompt)
                            .frame(height: 180)
                    }
                }
                .formStyle(.grouped)
            }

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
        .frame(width: 600, height: 500)
    }
}

// #Preview {
//    ParametersView()
//        .environment(ChatViewModel(modelContext: ModelContext(nil)))
// }
