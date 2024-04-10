//
//  AppStroe.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/8.
//

import Foundation

@Observable
class AppStroe {
    var models: [String] = []

    init() {
        models = ModelUtility.loadFromModelDirectory()
    }
}
