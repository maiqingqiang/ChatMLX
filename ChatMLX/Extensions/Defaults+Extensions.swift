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
    static let defaultModel = Key<String>("defaultModel", default: "")
    static let language = Key<Language>("language", default: .english)
    static let backgroundBlurRadius = Key<Double>("backgroundBlurRadius", default: 35)
    static let backgroundColor = Key<Color>("backgroundColor", default: .black.opacity(0.4))
    static let huggingFaceEndpoint = Key<String>("huggingFaceEndpoint", default: "https://huggingface.co")
    static let customHuggingFaceEndpoints = Key<[String]>("customHuggingFaceEndpoints", default: [])
    static let useCustomHuggingFaceEndpoint = Key<Bool>("useCustomHuggingFaceEndpoint", default: false)
    static let huggingFaceToken = Key<String?>("huggingFaceToken", default: nil)

    static let defaultTitle = Key<String>("defaultTitle", default: "Default Conversation")
    static let defaultTemperature = Key<Float>("defaultTemperature", default: 0.6)
    static let defaultTopP = Key<Float>("defaultTopP", default: 1.0)
    static let defaultMaxLength = Key<Int>("defaultMaxLength", default: 256)
    static let defaultRepetitionContextSize = Key<Int>("defaultRepetitionContextSize", default: 20)
    static let defaultMaxMessagesCount = Key<Int>("defaultMaxMessagesCount", default: 20)
    static let defaultUseMaxMessagesCount = Key<Bool>("defaultUseMaxMessagesCount", default: false)
    static let defaultRepetitionPenalty = Key<Float>("defaultRepetitionPenalty", default: 0)
    static let defaultUseRepetitionPenalty = Key<Bool>("defaultUseRepetitionPenalty", default: false)
    
    static let gpuCacheLimit = Key<Int>("gpuCacheLimit", default: 128)
}
