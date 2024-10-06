//
//  FireworkController.swift
//  Firework
//
//  Created by 秋星桥 on 2024/2/7.
//

import AppKit
import SwiftUI

class AppleIntelligenceEffectController: NSWindowController {
    override init(window: NSWindow?) {
        super.init(window: window)
        contentViewController = AppleIntelligenceEffectViewController()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }

    convenience init(screen: NSScreen) {
        let window = NoneInteractWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        self.init(window: window)
    }
}

extension AppleIntelligenceEffectController {
    func configureWindow(for screen: NSScreen) {
        window?.setFrameOrigin(screen.frame.origin)
        window?.setContentSize(screen.frame.size)
        window?.orderFrontRegardless()
    }
}

class AppleIntelligenceEffectViewController: NSViewController {
    override func loadView() {
        view = NSHostingView(rootView: AppleIntelligenceEffectView())
    }

    func fadeOut(completion: (() -> Void)?) {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.isRemovedOnCompletion = true
        view.layer?.add(fadeOutAnimation, forKey: "opacity")
        view.layer?.opacity = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion?()
        }
    }
}
