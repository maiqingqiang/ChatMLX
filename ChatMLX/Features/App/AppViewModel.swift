//
//  AppViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import Foundation

@Observable
class AppViewModel {
    var selectedTab: Featrue.Name = .prompt

    func switchTab(_ featrue: Featrue) {
        selectedTab = featrue.name
    }
}
