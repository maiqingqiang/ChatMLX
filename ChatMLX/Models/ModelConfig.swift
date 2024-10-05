//
//  ModelConfig.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import Defaults

enum Provider: String, Defaults.Serializable {
    case mlx
}

struct ModelConfig {
    var name: String
    var path: String
    var provider: Provider
    var description: String
}
