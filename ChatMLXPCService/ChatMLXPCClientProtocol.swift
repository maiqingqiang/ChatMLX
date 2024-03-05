//
//  ChatMLXPCClientProtocol.swift
//  ChatMLXPCService
//
//  Created by John Mai on 2024/3/4.
//

import Foundation

@objc protocol ChatMLXPCClientProtocol {
    func onTokenizerDecoder(token: String)
}
