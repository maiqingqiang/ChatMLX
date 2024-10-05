//
//  LabeledContentStyle+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/5.
//

import SwiftUI

struct HorizontalLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            configuration.content
        }
    }
}

extension LabeledContentStyle where Self == HorizontalLabeledContentStyle {
    static var horizontal: HorizontalLabeledContentStyle { .init() }
}
