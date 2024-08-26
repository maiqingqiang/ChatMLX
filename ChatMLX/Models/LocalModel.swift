//
//  LocalModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/14.
//

import Defaults
import Foundation

struct LocalModel: Identifiable {
    let id = UUID()
    let group: String
    let name: String
    let url: URL
    
    var origin:String {
        "\(group)/\(name)"
    }

    var isDefault: Bool {
        get {
            Defaults[.defaultModel] == origin
        }
        set {
            if newValue {
                Defaults[.defaultModel] = origin
            } else if Defaults[.defaultModel] == origin {
                Defaults[.defaultModel] = nil
            }
        }
    }
}
