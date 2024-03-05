//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/2/28.
//

import SwiftData
import SwiftUI

@main
struct ChatMLXApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
        }
        
        Settings {
            SettingView()
        }
    }
}
