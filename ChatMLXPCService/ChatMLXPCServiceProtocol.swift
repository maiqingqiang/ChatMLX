//
//  ChatMLXPCServiceProtocol.swift
//  ChatMLXPCService
//
//  Created by John Mai on 2024/3/3.
//

import Foundation

let ChatMLXPCServiceBundleIdentifier = "top.johnmai.ChatMLXPCService"

@objc protocol ChatMLXPCServiceProtocol {
    func generate(modelDirectory: URL, prompt: String, maxTokens: Int, temperature: Float, seed: UInt64, complete: @escaping (Error?) -> Void)
    func stop()
}
