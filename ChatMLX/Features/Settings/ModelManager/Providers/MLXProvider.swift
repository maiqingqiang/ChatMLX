//
//  MLXProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import CompactSlider
import Defaults
import Luminare
import SwiftUI

struct MLXProvider: View {
    @State var isExpanded: Bool = true

    let maxRAM = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)

    @Default(.gpuCacheLimit) var gpuCacheLimit

    @Default(.gpuMemoryLimit) var gpuMemoryLimit

    @Environment(LLMRunner.self) var runner

    var body: some View {
        ProviderView(isExpanded: $isExpanded, isEnabled: .constant(nil)) {
            Label()
        } content: {
            Content()
                .labeledContentStyle(.horizontal)
                .compactSliderSecondaryColor(.white)
        }
    }

    @ViewBuilder
    func Label() -> some View {
        HStack(spacing: 0) {
            Text("ML")
                .foregroundStyle(.black)
            Text("X")
                .foregroundStyle(Color(hex: "#D5D5D5"))
        }
        .font(.title2.weight(.medium))
    }

    @ViewBuilder
    func Content() -> some View {
        LabeledContent("GPU Cache Limit") {
            CompactSlider(
                value: $gpuCacheLimit.asDouble(), in: 0 ... Double(maxRAM), step: 128
            ) {
                Text("\(Int(gpuCacheLimit))MB")
                    .foregroundStyle(.white)
            }
            .frame(width: 200)
            .onChange(of: gpuCacheLimit) { oldValue, newValue in
                if oldValue != newValue {
                    runner.loadState = .idle
                }
            }
        }

        LabeledContent("GPU Memory Limit") {
            CompactSlider(
                value: $gpuMemoryLimit.asDouble(), in: 0 ... Double(maxRAM), step: 128
            ) {
                Text("\(Int(gpuMemoryLimit))MB")
                    .foregroundStyle(.white)
            }
            .frame(width: 200)
            .onChange(of: gpuMemoryLimit) { oldValue, newValue in
                if oldValue != newValue {
                    runner.loadState = .idle
                }
            }
        }
    }
}
