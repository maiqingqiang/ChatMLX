//
//  AppleIntelligenceEffectManager.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/6.
//

import AppKit

class AppleIntelligenceEffectManager {
    static let shared = AppleIntelligenceEffectManager()

    private var effectController: AppleIntelligenceEffectController?

    private init() {}

    func setupEffect() {
        guard effectController == nil, let screen = NSScreen.main else { return }
        effectController = AppleIntelligenceEffectController(screen: screen)
        effectController?.configureWindow(for: screen)
    }

    func closeEffect(completion: (() -> Void)? = nil) {
        guard let controller = effectController else {
            completion?()
            return
        }

        (controller.contentViewController as? AppleIntelligenceEffectViewController)?.fadeOut {
            [weak self] in
            controller.window?.close()
            self?.effectController = nil
            completion?()
        }
    }
}
