//
//  AnimationDisplayOption.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/7.
//

import Defaults
import SwiftUI

enum AppleIntelligenceEffectDisplay: String, CaseIterable, Identifiable, Defaults.Serializable {
    case global = "Global"
    case appInternal = "Internal"

    var id: String { rawValue }

    var localized: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
