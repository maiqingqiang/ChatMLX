//
//  Defaults+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/14.
//
import Defaults

extension Defaults.Keys {
    static let enabledModels = Key<Set<String>>("enabledModels", default: [])
    static let defaultModel = Key<String?>("defaultModel", default: nil)
}
