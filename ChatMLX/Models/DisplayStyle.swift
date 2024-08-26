//
//  DisplayStyle.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import Foundation

enum DisplayStyle: String, CaseIterable, Identifiable {
    case plain, markdown
    var id: Self { self }
}
