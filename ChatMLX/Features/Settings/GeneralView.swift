//
//  GeneralView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/18.
//

import CompactSlider
import Defaults
import Luminare
import SwiftUI

struct GeneralView: View {
    @Default(.backgroundBlurRadius) var blurRadius
    @Default(.backgroundColor) var backgroundColor
    @Default(.language) var language
    
    @Environment(\.modelContext) private var modelContext


    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Language") {
                HStack {
                    Text("Language")
                    Spacer()
                    Picker(
                        "Language",
                        selection: $language
                    ) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .labelsHidden()
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                .padding(8)
            }

            LuminareSection("Window Appearance") {
                HStack {
                    Text("Blur")
                    Spacer()
                    CompactSlider(value: $blurRadius, in: 0...100) {
                        Text("\(Int(blurRadius))")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200)
                    .compactSliderSecondaryColor(.white)
                }
                .padding(5)

                HStack {
                    Text("Color")
                    Spacer()
                    ColorPicker("", selection: $backgroundColor)
                        .labelsHidden()
                }
                .padding(5)
            }

            LuminareSection("System Settings") {
                Button("Reset All Settings", action: resetAllSettings)
                    .frame(height: 35)
            }
            .buttonStyle(LuminareDestructiveButtonStyle())

            Spacer()
        }

        .ultramanNavigationTitle("General")
        .padding()
    }

    private func resetAllSettings() {
        Defaults.reset(.backgroundBlurRadius)
        Defaults.reset(.backgroundColor)
        Defaults.reset(.language)
    }
}

#Preview {
    GeneralView()
}
