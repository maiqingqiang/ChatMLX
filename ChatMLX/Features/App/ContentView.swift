//
//  ContentView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppViewModel.self) private var vm

    var body: some View {
        switch vm.selectedTab {
        case .chat:
            ChatSidebarView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
