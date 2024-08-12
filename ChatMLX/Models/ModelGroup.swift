//
//  ModelGroup.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import Foundation

struct ModelGroup: Identifiable {
    let id = UUID()
    let name: String
    var models: [Model]
}
