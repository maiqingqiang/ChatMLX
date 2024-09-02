//
//  RightSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/5.
//

import CompactSlider
import Luminare
import SwiftUI

struct RightSidebarView: View {
    @Binding var conversation: Conversation

    private let padding: CGFloat = 6

    var body: some View {
        ScrollView {
            VStack {
                LuminareSection("Conversation Title") {
                    UltramanTextField(
                        Binding(
                            get: {
                                conversation.title
                            },
                            set: { title in
                                conversation.title = title
                            }
                        ), placeholder: Text("Conversation Title")
                    )
                    .frame(height: 25)
                }

                LuminareSection("Model Settings") {
                    HStack {
                        Text("Temperature")
                        Spacer()
                        CompactSlider(
                            value: $conversation.temperature, in: 0 ... 2,
                            step: 0.01
                        ) {
                            Text(
                                "\(conversation.temperature, specifier: "%.2f")"
                            )
                            .foregroundStyle(.white)
                        }
                        .frame(width: 100)
                    }
                    .padding(padding)

                    HStack {
                        Text("Top P")
                        Spacer()
                        CompactSlider(
                            value: $conversation.topP, in: 0 ... 1, step: 0.01
                        ) {
                            Text("\(conversation.topP, specifier: "%.2f")")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 100)
                    }
                    .padding(padding)

                    HStack {
                        Text("Use Max Length")
                        Spacer()
                        Toggle("", isOn: $conversation.useMaxLength)
                            .labelsHidden()
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if conversation.useMaxLength {
                        HStack {
                            Text("Max Length")
                            Spacer()
                            CompactSlider(
                                value: Binding(
                                    get: {
                                        Double(conversation.maxLength)
                                    },
                                    set: {
                                        conversation.maxLength = Int($0)
                                    }
                                ), in: 0 ... 8192, step: 1
                            ) {
                                Text("\(Int(conversation.maxLength))")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 100)
                        }
                        .padding(padding)
                    }

                    HStack {
                        Text("Repetition Context Size")
                        Spacer()
                        CompactSlider(
                            value: Binding(
                                get: {
                                    Double(conversation.repetitionContextSize)
                                },
                                set: {
                                    conversation.repetitionContextSize = Int($0)
                                }
                            ), in: 0 ... 100, step: 1
                        ) {
                            Text("\(conversation.repetitionContextSize)")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 100)
                    }
                    .padding(padding)

                    HStack {
                        Text("Use Repetition Penalty")
                        Spacer()
                        Toggle("", isOn: $conversation.useRepetitionPenalty)
                            .labelsHidden()
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if conversation.useRepetitionPenalty {
                        HStack {
                            Text("Repetition Penalty")
                            Spacer()
                            CompactSlider(
                                value: $conversation.repetitionPenalty,
                                in: 1 ... 2,
                                step: 0.01
                            ) {
                                Text(
                                    "\(conversation.repetitionPenalty, specifier: "%.2f")"
                                )
                                .foregroundStyle(.white)
                            }
                            .frame(width: 100)
                        }
                        .padding(padding)
                    }
                }
                .compactSliderSecondaryColor(.white)

                LuminareSection("Message Control") {
                    HStack {
                        Text("Use Max Messages Limit")
                        Spacer()
                        Toggle("", isOn: $conversation.useMaxMessagesLimit)
                            .labelsHidden()
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if conversation.useMaxMessagesLimit {
                        HStack {
                            Text("Max Messages Limit")
                            Spacer()
                            CompactSlider(
                                value: Binding(
                                    get: {
                                        Double(conversation.maxMessagesLimit)
                                    },
                                    set: {
                                        conversation.maxMessagesLimit = Int($0)
                                    }
                                ), in: 1 ... 50, step: 1
                            ) {
                                Text("\(conversation.maxMessagesLimit)")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 100)
                        }
                        .padding(padding)
                    }
                }
                .compactSliderSecondaryColor(.white)

                LuminareSection("System Prompt") {
                    HStack {
                        Text("Use System Prompt")
                        Spacer()
                        Toggle("", isOn: $conversation.useSystemPrompt)
                            .labelsHidden()
                            .toggleStyle(.switch)
                    }
                    .padding(padding)

                    if conversation.useSystemPrompt {
                        UltramanTextEditor(
                            text: $conversation.systemPrompt,
                            placeholder: "System prompt",
                            onSubmit: {

                            }
                        )
                        .frame(height: 100)
                        .padding(padding)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .frame(width: 260)
        .transition(.move(edge: .trailing))
        .background(.black.opacity(0.3))
        .scrollContentBackground(.hidden)
        .background(
            EffectView(
                .hudWindow,
                blendingMode: .withinWindow,
                emphasized: true
            )
        )
    }
}
