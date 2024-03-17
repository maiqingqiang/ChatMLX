//
//  Model.swift
//
//
//  Created by John Mai on 2024/3/14.
//

import Foundation

struct MLXModel {
    let id: UUID = .init()
    let name: String
    var isAvailable: Bool = false
    var progress: Double = 0
    var isRecommended: Bool = false
    var isDownloading: Bool = false
    var totalFileCount: Int64 = 0
    var completedFileCount: Int64 = 0
}

extension MLXModel: Equatable, Hashable, Identifiable {}
