//
//  Model.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/5.
//

import Foundation

struct Model: Equatable, Identifiable {
    var id: UUID = .init()
    var name: String
    var url: URL
}
