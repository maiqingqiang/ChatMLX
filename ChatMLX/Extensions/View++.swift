//
//  View++.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import Foundation
import SwiftUI

extension View {
    func titlebarAppearsTransparentWithUnified(_ identifier: String) -> some View {
        modifier(TitlebarAppearsTransparentWithUnified(identifier))
    }
    
    func titlebarUnified(_ identifier: String) -> some View {
        modifier(TitlebarUnified(identifier))
    }
}

struct TitlebarAppearsTransparentWithUnified: ViewModifier {
    let identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
    }

    func body(content: Content) -> some View {
        content
            .task {
                guard
                    let window = NSApp.windows.first(where: {
                        $0.identifier?.rawValue == identifier
                    })
                else { return }
                window.titlebarAppearsTransparent = true
                window.toolbarStyle = .unified
            }
    }
}

struct TitlebarUnified: ViewModifier {
    let identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
    }

    func body(content: Content) -> some View {
        content
            .task {
                guard
                    let window = NSApp.windows.first(where: {
                        $0.identifier?.rawValue == identifier
                    })
                else { return }
                window.toolbarStyle = .unified
            }
    }
}
