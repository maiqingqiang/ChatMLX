//
//  UltramanWindow.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftUI

class UltramanWindow: NSWindow {
    static var identifier = NSUserInterfaceItemIdentifier("UltramanWindow")

    init(rootView:()-> some View) {
        super.init(
            contentRect: .zero,
            styleMask: [.closable, .titled, .fullSizeContentView, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        
        let view = NSHostingView(
            rootView: rootView()
        )
        
        contentView = view
        contentView?.wantsLayer = true
        setContentSize(view.bounds.size)
        
        toolbarStyle = .unified
        titlebarAppearsTransparent = true
        titleVisibility = .hidden

        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        toolbar = customToolbar
        
        setBackgroundBlur(radius: 20)
        identifier = Self.identifier
        
        alphaValue = 0
        
        makeKeyAndOrderFront(self)
        orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)

        DispatchQueue.main.async {
            self.center()
            self.alphaValue = 1
        }
    }
}
