//
//  Item.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
