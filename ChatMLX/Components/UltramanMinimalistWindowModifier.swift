//
//  UltramanMinimalistWindowModifier.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI
import SwiftUIIntrospect

struct UltramanMinimalistWindowModifier: ViewModifier {
    private var fullScreenPresentationWindowDelegate = FullScreenPresentationWindowDelegate()
    
    func body(content: Content) -> some View {
        content
            .ignoresSafeArea()
            .introspect(.window, on: .macOS(.v14, .v15)) { window in
                window.setBackgroundBlur(radius: 20)
                window.toolbarStyle = .unified
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden

                let toolbar = NSToolbar()
                toolbar.showsBaselineSeparator = false
                window.toolbar = toolbar
                window.delegate = fullScreenPresentationWindowDelegate
            }
    }
}

extension View {
    func ultramanMinimalistWindowStyle() -> some View {
        modifier(UltramanMinimalistWindowModifier())
    }
}
