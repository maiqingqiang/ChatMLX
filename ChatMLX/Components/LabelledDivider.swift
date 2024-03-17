//
//  SwiftUIView.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import SwiftUI

struct LabelledDivider: View {
    let label: String
    let color: Color

    init(label: String, color: Color = .gray.opacity(0.3)) {
        self.label = label
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label)
            line
        }
        .foregroundColor(color)
    }

    var line: some View {
        VStack {
            Divider()
        }
    }
}

#Preview {
    LabelledDivider(label: "hi")
}
