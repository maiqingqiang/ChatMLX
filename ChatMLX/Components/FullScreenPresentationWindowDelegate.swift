//
//  FullScreenPresentationWindowDelegate.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/5.
//

import SwiftUI

class FullScreenPresentationWindowDelegate: NSObject, NSWindowDelegate {
    func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
        [.autoHideToolbar, .autoHideMenuBar, .fullScreen]
    }
}
