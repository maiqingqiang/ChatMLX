//
//  ExperimentalFeaturesView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/7.
//

import Defaults
import Luminare
import SwiftUI

struct ExperimentalFeaturesView: View {
    @Default(.enableAppleIntelligenceEffect) var enableAppleIntelligenceEffect
    @Default(.appleIntelligenceEffectDisplay) var appleIntelligenceEffectDisplay

    @State private var showingPopover: Bool = false

    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Window Appearance") {
                HStack {
                    Text("Apple Intelligence Effect")
                    Spacer()
                    Toggle("", isOn: $enableAppleIntelligenceEffect)
                        .toggleStyle(.switch)
                }
                .padding(6)

                if enableAppleIntelligenceEffect {
                    HStack {
                        Text("Display Mode")
                        Spacer()
                        Picker(
                            "Display Mode",
                            selection: $appleIntelligenceEffectDisplay
                        ) {
                            ForEach(AppleIntelligenceEffectDisplay.allCases) { display in
                                Text(display.rawValue).tag(display)
                            }
                        }
                        .labelsHidden()
                        .buttonStyle(.borderless)
                        .foregroundStyle(.white)
                        .tint(.white)
                    }
                    .padding(8)
                }
            }
            Spacer()
        }
        .ultramanToolbar(alignment: .trailing) {
            Button(action: {
                showingPopover = true
            }) {
                Image(systemName: "exclamationmark.triangle")
            }
            .buttonStyle(.plain)
            .symbolRenderingMode(.multicolor)
            .popover(isPresented: $showingPopover, arrowEdge: .bottom) {
                Text(
                    "Experimental features may have performance limitations. Features and programmatic interfaces are subject to change at any time."
                )
                .frame(width: 200)
                .padding()
            }
        }
        .ultramanNavigationTitle("Experimental Features")
        .padding()
    }
}
