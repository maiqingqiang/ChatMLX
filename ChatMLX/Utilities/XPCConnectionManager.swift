//
//  XPCConnectionManager.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/4.
//

import Foundation
import os

typealias tokenizerDecoder = (String) -> Void
typealias Complete = (Error?) -> Void

class XPCConnectionManager: NSObject, ObservableObject, ChatMLXPCClientProtocol {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "XPCConnectionManager")

    private var connection: NSXPCConnection!

    var tokenizerDecoder: tokenizerDecoder?

    private func establishConnection() {
        connection = NSXPCConnection(serviceName: ChatMLXPCServiceBundleIdentifier)
        connection.remoteObjectInterface = NSXPCInterface(with: ChatMLXPCServiceProtocol.self)

        connection.exportedObject = self
        connection.exportedInterface = NSXPCInterface(with: ChatMLXPCClientProtocol.self)

        connection.interruptionHandler = {
            self.logger.warning("connection to XPC service has been interrupted")
        }

        connection.invalidationHandler = {
            self.logger.warning("connection to XPC service has been invalidated")
            self.connection = nil
        }

        connection.resume()
    }

    func service() -> ChatMLXPCServiceProtocol {
        if connection == nil {
            establishConnection()
        }

        return connection.remoteObjectProxyWithErrorHandler { error in
            self.logger.error("remoteObjectProxyWithErrorHandler \(error.localizedDescription)")
        } as! ChatMLXPCServiceProtocol
    }

    func invalidateConnection() {
        guard connection != nil else { logger.info("no connection to invalidate"); return }
        connection.invalidate()
    }

    func generate(modelDirectory: URL, prompt: String, maxTokens: Int, temperature: Float, seed: UInt64, complete: @escaping Complete, tokenizerDecoder: @escaping tokenizerDecoder) {
        self.tokenizerDecoder = tokenizerDecoder
        service().generate(modelDirectory: modelDirectory, prompt: prompt, maxTokens: maxTokens, temperature: temperature, seed: seed, complete: complete)
    }

    func onTokenizerDecoder(token: String) {
        tokenizerDecoder?(token)
    }
}
