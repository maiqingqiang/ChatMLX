//
//  UltramanMinimalistWindowModifier.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import AppKit
import Defaults
import SwiftUI
import SwiftUIIntrospect

struct UltramanMinimalistWindowModifier: ViewModifier {
    @Default(.backgroundBlurRadius) var blurRadius
    @Default(.backgroundColor) var backgroundColor
    @State private var isFullScreen = false

    func body(content: Content) -> some View {
        content
            .ignoresSafeArea()
            .introspect(.window, on: .macOS(.v14, .v15)) { window in
                window.setBackgroundBlur(
                    radius: Int(blurRadius), color: NSColor(backgroundColor))
                window.toolbarStyle = .unified
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden

                let toolbar = NSToolbar()
                toolbar.showsBaselineSeparator = false
                window.toolbar = toolbar

                NotificationCenter.default.addObserver(
                    forName: NSWindow.didEnterFullScreenNotification,
                    object: window, queue: .main
                ) { _ in
                    self.isFullScreen = true
                    self.updateFullScreenSettings(for: window)
                }

                NotificationCenter.default.addObserver(
                    forName: NSWindow.didExitFullScreenNotification,
                    object: window, queue: .main
                ) { _ in
                    self.isFullScreen = false
                    self.updateFullScreenSettings(for: window)
                }
            }
    }

    private func updateFullScreenSettings(for window: NSWindow) {
        if isFullScreen {
            window.collectionBehavior.insert(.fullScreenPrimary)
            window.toolbar?.isVisible = false
            NSApp.presentationOptions = [
                .autoHideToolbar, .autoHideMenuBar, .fullScreen,
            ]
        } else {
            window.collectionBehavior.remove(.fullScreenPrimary)
            window.toolbar?.isVisible = true
            NSApp.presentationOptions = []
        }
    }
}

extension View {
    func ultramanMinimalistWindowStyle() -> some View {
        modifier(UltramanMinimalistWindowModifier())
    }
}
