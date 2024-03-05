//
//  ChatMLXPCService.swift
//  ChatMLXPCService
//
//  Created by John Mai on 2024/3/3.
//

import AsyncAlgorithms
import Foundation
import MLX
import MLXRandom
import os
import SwiftUI

class ChatMLXPCService: NSObject, NSXPCListenerDelegate, ChatMLXPCServiceProtocol {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "ChatMLXPCService")

    var cancelled: Bool = false
    
    let listener: NSXPCListener
    var connection: NSXPCConnection?
    
    var client: ChatMLXPCClientProtocol {
        connection!.remoteObjectProxyWithErrorHandler { error in
            self.logger.error("client remoteObjectProxyWithErrorHandler \(error.localizedDescription)")
        } as! ChatMLXPCClientProtocol
    }
    
    override init() {
        listener = NSXPCListener(machServiceName: ChatMLXPCServiceBundleIdentifier)
        super.init()
        listener.delegate = self
    }
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: ChatMLXPCServiceProtocol.self)
        newConnection.exportedObject = self
        newConnection.remoteObjectInterface = NSXPCInterface(with: ChatMLXPCClientProtocol.self)
        newConnection.resume()
        
        connection = newConnection
        
        return true
    }
    
    func generate(modelDirectory: URL, prompt: String, maxTokens: Int, temperature: Float, seed: UInt64, complete: @escaping (Error?) -> Void) {
        Task { @MainActor [unowned self] in
            do {
                logger.info("model: \(modelDirectory)")
                
                MLXRandom.seed(seed)
                
                let modelConfiguration = ModelConfiguration.configuration(id: modelDirectory.relativeString)
                let (model, tokenizer, tokenizerClass) = try await loadModel(modelDirectory: modelDirectory, configuration: modelConfiguration)
                let old_prompt = prompt
//                tokenizer.config.dictionary["tokenizer_class"]
                var prompt = "<|im_start|>user\n\(old_prompt)<|im_end|>\n<|im_start|>assistant\n"
                
                if tokenizerClass == "GemmaTokenizer" {
                    prompt = "<start_of_turn>user\n\(old_prompt)<end_of_turn>\n<start_of_turn>model\n"
                } else if tokenizerClass == "CodeLlamaTokenizer" {
                    prompt = "<PRE> " + old_prompt.replacingOccurrences(of: "<FILL_ME>", with: "<SUF>") + " <MID>"
                } else if tokenizerClass == "LlamaTokenizer" {
                    prompt = old_prompt
                } else if tokenizerClass == "CodeGenTokenizer" {
                    prompt = "Instruct: \(old_prompt)\nOutput: "
                }
                
//                let prompt = modelConfiguration.prepare(prompt: prompt)
                
                let promptTokens = tokenizer.encode(text: prompt)
                
                logger.debug("Starting generation ...")
                logger.debug("prompt: \(prompt)")
                
                var start = Date.timeIntervalSinceReferenceDate
                var promptTime: TimeInterval = 0
                
                var tokens = [Int]()
                var printed = 0
                
                for token in TokenIterator(prompt: MLXArray(promptTokens), model: model, temp: temperature) {
                    if tokens.isEmpty {
                        eval(token)
                        let now = Date.timeIntervalSinceReferenceDate
                        promptTime = now - start
                        start = now
                    }
                    
                    let t = token.item(Int.self)
                    if t == tokenizer.unknownTokenId || t == tokenizer.eosTokenId {
                        break
                    }
                    tokens.append(t)
                    
                    // print any new parts of the string
                    let fullOutput = tokenizer.decode(tokens: tokens)
                    let emitLength = fullOutput.count - printed
                    let suffix = fullOutput.suffix(emitLength)
                    
                    self.client.onTokenizerDecoder(token: String(suffix))
                    
                    printed = fullOutput.count
                    
                    if tokens.count == maxTokens {
                        break
                    }
                }
                
                let now = Date.timeIntervalSinceReferenceDate
                let generateTime = now - start
                
                print(
                    """
                    Prompt Tokens per second:     \((Double(promptTokens.count) / promptTime).formatted())
                    Generation tokens per second: \((Double(tokens.count - 1) / generateTime).formatted())
                    """)
                complete(nil)
            } catch {
                logger.error("generate \(error.localizedDescription)")
                complete(error)
            }
        }
    }

    func stop() {
        cancelled = true
    }
}
