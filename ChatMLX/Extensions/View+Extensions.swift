//
//  View+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func placeholder(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> some View) -> some View
    {
        ZStack(alignment: alignment) {
            placeholder()
                .padding(2)
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
    
    func printSafeAreaInsets(id: String) -> some View {
            background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
                }
                .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                    print("\(id) insets:\(value)")
                }
            )
        }
}
