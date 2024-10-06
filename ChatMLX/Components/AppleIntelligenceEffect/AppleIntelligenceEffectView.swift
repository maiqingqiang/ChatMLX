//
//  AppleIntelligenceEffectView.swift
//  test
//
//  Created by John Mai on 2024/10/6.
//

import SwiftUI

struct AppleIntelligenceEffectView: View {
    private let shader = ShaderLibrary.colorWheel(.boundingRect, .float(1))
    private let angles = [133.0, -133.0]
    private let maxBlurRadiusBase: CGFloat = 18
    private let minBlurRadiusBase: CGFloat = 6

    var body: some View {
        TimelineView(.animation) { timeline in
            ZStack {
                ForEach(angles.indices, id: \.self) { index in
                    colorWheelRectangle(for: timeline.date, angle: angles[index])
                }
            }
        }
    }

    @MainActor
    private func colorWheelRectangle(for date: Date, angle: Double) -> some View {
        let time = date.timeIntervalSince1970
        let blurRadius =
            angle > 0
            ? maxBlurRadiusBase + 6 * sin(time * 2) : minBlurRadiusBase + 3 * sin(time * 4)

        return Rectangle()
            .fill(shader)
            .rotationEffect(.degrees(time * 60))
            .scaleEffect(2.4)
            .rotationEffect(.degrees(time * angle))
            .mask(alignment: .center) {
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 20,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: 20
                    )
                )
                .stroke(lineWidth: maxBlurRadiusBase)
                .blur(radius: blurRadius)
            }
    }
}
