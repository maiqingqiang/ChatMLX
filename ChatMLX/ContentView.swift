//
//  ContentView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    private var fullScreenPresentationWindowDelegate = FullScreenPresentationWindowDelegate()

    var body: some View {
        ChatView()
            .frame(minWidth: 900, minHeight: 580)
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

#Preview {
    ContentView()
}
