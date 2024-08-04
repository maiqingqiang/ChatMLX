//
//  View+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

extension View {
    func placeholder(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> some View) -> some View
    {
        ZStack(alignment: alignment) {
            
            placeholder()
                .padding(.horizontal, 2)
                .opacity(shouldShow ? 1 : 0)
            self
        }
    }

    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View
    {
        placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.white.opacity(0.6)) }
    }
}
