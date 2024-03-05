// Copyright © 2024 Apple Inc.

import AsyncAlgorithms
import Foundation
import Hub
import MLX
import MLXNN
import MLXRandom
import Tokenizers

struct LLMError: Error {
    let message: String
}

public func readConfiguration(from filename: String, in repo: URL) throws -> Config {
//    print(repo.path()+filename)
    let data = try Data(contentsOf: repo.appending(component: filename))
    let parsed = try JSONSerialization.jsonObject(with: data, options: [])
    guard let dictionary = parsed as? [String: Any] else { throw Hub.HubClientError.parse }
    return Config(dictionary)
}

/// Load and return the model and tokenizer
public func loadModel(
    modelDirectory: URL,
    hub: HubApi = HubApi(), configuration: ModelConfiguration,
    progressHandler: @escaping (Progress) -> Void = { _ in }) async throws -> (LLMModel, Tokenizer, String)
{
    // note: this doesn't have a way to pass the HubApi
//    let tokenizer = try await loadTokenizer(configuration: configuration)

//    let config = LanguageModelConfigurationFromHub(
//        modelName: configuration.tokenizerId ?? configuration.id)
    let modelConfig = try readConfiguration(from: "config.json", in: modelDirectory)
    let tokenizerConfig = try? readConfiguration(from: "tokenizer_config.json", in: modelDirectory)
    let tokenizerVocab = try readConfiguration(from: "tokenizer.json", in: modelDirectory)

    guard var tokenizerConfig = try await tokenizerConfig else {
        throw LLMError(message: "missing config")
    }
    var tokenizerData = try await tokenizerVocab

    let old_tokenizer_class = tokenizerConfig.tokenizerClass?.stringValue ?? ""

    // workaround: replacement tokenizers for unhandled values in swift-transform
    if let tokenizerClass = tokenizerConfig.tokenizerClass?.stringValue,
       let replacement = replacementTokenizers[tokenizerClass]
    {
        var dictionary = tokenizerConfig.dictionary
        dictionary["tokenizer_class"] = replacement
        tokenizerConfig = Config(dictionary)
    }

    // workaround: some merges can't be split on space in BPETokenizer
    if let tokenizerClass = tokenizerConfig.tokenizerClass?.stringValue {
        switch tokenizerClass {
        case "T5Tokenizer":
            break
        default:
            tokenizerData = discardUnhandledMerges(tokenizerData: tokenizerData)
        }
    }

    let impl = try PreTrainedTokenizer(
        tokenizerConfig: tokenizerConfig, tokenizerData: tokenizerData)

    let tokenizer = Tokenizer(tokenizer: impl, tokenizerConfig: tokenizerConfig)

    // download the model weights and config
//    let repo = Hub.Repo(id: configuration.id)
//    let modelFiles = ["config.json", "*.safetensors"]
//    let modelDirectory = try await hub.snapshot(
//        from: repo, matching: modelFiles, progressHandler: progressHandler)

    // create the model (no weights loaded)
    let configurationURL = modelDirectory.appending(component: "config.json")
    let baseConfig = try JSONDecoder().decode(
        BaseConfiguration.self, from: Data(contentsOf: configurationURL))

    let model = try baseConfig.modelType.createModel(configuration: configurationURL)

    // load the weights
    var weights = [String: MLXArray]()
    let enumerator = FileManager.default.enumerator(
        at: modelDirectory, includingPropertiesForKeys: nil)!
    for case let url as URL in enumerator {
        if url.pathExtension == "safetensors" {
            let w = try loadArrays(url: url)
            for (key, value) in w {
                weights[key] = value
            }
        }
    }

    // quantize if needed
    if let quantization = baseConfig.quantization {
        quantizeIfNeeded(model: model, weights: weights, quantization: quantization)
    }

    // apply the loaded weights
    let parameters = ModuleParameters.unflattened(weights)
    try model.update(parameters: parameters, verify: [.all])

    eval(model)

    return (model, tokenizer, old_tokenizer_class)
}

// MARK: - Quantization

private func quantizeIfNeeded(
    model: LLMModel, weights: [String: MLXArray], quantization: BaseConfiguration.Quantization)
{
    func linearPredicate(layer: Module) -> Bool {
        if let layer = layer as? Linear {
            // avoid quantizing gate layers, otherwise we have to re-quant and upload all the mixtral models
            return layer.weight.dim(0) != 8
        }
        return false
    }

    var predicate = linearPredicate(layer:)

    // for legacy models that don't have lm_head quant due to non-32 dims
    if weights["lm_head.scales"] == nil {
        let vocabularySize = model.vocabularySize

        func vocabularySizePredicate(layer: Module) -> Bool {
            if let layer = layer as? Linear {
                return layer.weight.dim(0) != 8 && layer.weight.dim(0) != vocabularySize
            }
            return false
        }

        predicate = vocabularySizePredicate(layer:)
    }

    QuantizedLinear.quantize(
        model: model, groupSize: quantization.groupSize, bits: quantization.bits,
        predicate: predicate)
}
