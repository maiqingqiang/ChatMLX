//
//  Model.swift
//
//
//  Created by John Mai on 2024/3/14.
//

import Foundation

enum MLXModelState {
    case unavailable
    case availabled
    case downloading(progress: Double, totalFileCount: Int64, completedFileCount: Int64)
}

@Observable
class MLXModel {
    let id: UUID = .init()
    let name: String
//    var isAvailable: Bool = false
//    var progress: Double = 0
    var recommended: Bool = false
    //    var isDownloading: Bool = false
//    var totalFileCount: Int64 = 0
//    var completedFileCount: Int64 = 0
    var state: MLXModelState = .unavailable

    init(name: String) {
        self.name = name
    }

    init(name: String, recommended: Bool = false) {
        self.name = name
        self.recommended = recommended
    }
}

extension MLXModel: Equatable, Identifiable {
    static func == (lhs: MLXModel, rhs: MLXModel) -> Bool {
        lhs.name == rhs.name
    }
}
