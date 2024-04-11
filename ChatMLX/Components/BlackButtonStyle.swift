//
//  BlackButtonStyle.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/10.
//

import SwiftUI

struct BlackButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(7)
            .background(isEnabled ? Color.black : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .shadow(radius: 2)
    }
}
