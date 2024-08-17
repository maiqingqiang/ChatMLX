//
//  LocalModelGroup.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/14.
//

import Foundation

struct LocalModelGroup: Identifiable {
    let id = UUID()
    let name: String
    var models: [LocalModel]
}
