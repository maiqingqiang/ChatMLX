//
//  main.swift
//  ChatMLXPCService
//
//  Created by John Mai on 2024/3/3.
//

import Foundation

let service = ChatMLXPCService()
service.listener.resume()

RunLoop.main.run()
