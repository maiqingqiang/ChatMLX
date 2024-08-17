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

    var isDefault: Bool {
        get {
            Defaults[.defaultModel] == name
        }
        set {
            if newValue {
                Defaults[.defaultModel] = name
            } else if Defaults[.defaultModel] == name {
                Defaults[.defaultModel] = nil
            }
        }
    }
}
