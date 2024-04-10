//
//  Tokenizer.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/8.
//

import Foundation
import Hub
import Tokenizers

let replacementTokenizers = [
    "Qwen2Tokenizer": "PreTrainedTokenizer",
    "CohereTokenizer": "PreTrainedTokenizer",
]

public func loadTokenizer(modelName:String) async throws -> Tokenizer {
    // from AutoTokenizer.from() -- this lets us override parts of the configuration
    let config = LanguageModelConfigurationFromHub(
        modelName: modelName)
    guard var tokenizerConfig = try await config.tokenizerConfig else {
        throw ChatMLXError(message: "missing config")
    }
    let tokenizerData = try await config.tokenizerData

    // workaround: replacement tokenizers for unhandled values in swift-transform
    if let tokenizerClass = tokenizerConfig.tokenizerClass?.stringValue,
        let replacement = replacementTokenizers[tokenizerClass]
    {
        var dictionary = tokenizerConfig.dictionary
        dictionary["tokenizer_class"] = replacement
        tokenizerConfig = Config(dictionary)
    }

    return try PreTrainedTokenizer(
        tokenizerConfig: tokenizerConfig, tokenizerData: tokenizerData)
}
