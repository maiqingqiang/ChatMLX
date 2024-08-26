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
        VStack {
            LuminareSection("Conversation Title") {
                UltramanTextField(Binding(get: {
                    conversation.title
                }, set: { title in
                    conversation.title = title
                }), placeholder: Text("Conversation Title"))
                    .frame(height: 25)
            }

            LuminareSection("Model Settings") {
                HStack {
                    Text("Temperature")
                    Spacer()
                    CompactSlider(value: $conversation.temperature, in: 0...2) {
                        Text("\(conversation.temperature, specifier: "%.2f")")
                            .foregroundStyle(.white)
                    }
                }
                .padding(padding)

                HStack {
                    Text("Top P")
                    Spacer()
                    CompactSlider(
                        value: $conversation.topP, in: 0...1, step: 0.01
                    ) {
                        Text("\(conversation.topP, specifier: "%.2f")")
                            .foregroundStyle(.white)
                    }
                }
                .padding(padding)

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
                        ), in: 0...8192
                    ) {
                        Text("\(Int(conversation.maxLength))")
                            .foregroundStyle(.white)
                    }
                }
                .padding(padding)
            }
            .compactSliderSecondaryColor(.white)

            Spacer()
        }
        .padding()
        .frame(width: 260)
        .transition(.move(edge: .trailing))
        .background(.black.opacity(0.3))
        .background(
            EffectView(
                .hudWindow,
                blendingMode: .withinWindow,
                emphasized: true
            )
        )
    }
}
