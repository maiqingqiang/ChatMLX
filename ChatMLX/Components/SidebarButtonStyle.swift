//
//  SidebarButtonStyle.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/4.
//

import SwiftUI

struct SidebarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .focusEffectDisabled()
    }
}

#Preview {
    VStack {
        Button(action: {}) {
            Image(systemName: "message")
        }.buttonStyle(SidebarButtonStyle())
    }.frame(width: 200, height: 200)
}
