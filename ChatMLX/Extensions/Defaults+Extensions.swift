//
//  Defaults+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/14.
//
import Defaults
import SwiftUI

extension Defaults.Keys {
    static let enabledModels = Key<Set<String>>("enabledModels", default: [])
    static let defaultModel = Key<String?>("defaultModel", default: nil)
    static let language = Key<Language>("language", default: .english)
    static let backgroundBlurRadius = Key<Double>("backgroundBlurRadius", default: 20)
    static let backgroundColor = Key<Color>("backgroundColor", default: .black.opacity(0.4))
}
