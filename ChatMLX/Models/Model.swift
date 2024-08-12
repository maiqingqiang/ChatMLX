//
//  Model.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import Foundation

struct Model: Identifiable {
    let id = UUID()
    let name: String
    let group: String
    var isVisible: Bool
    var isDefault: Bool
}
