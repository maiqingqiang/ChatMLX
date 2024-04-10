//
//  AppView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/4.
//

import SwiftUI

struct AppView: View {
    @Environment(AppViewModel.self) private var vm
    @Namespace var animation
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SiderView()
        }
        content: {
            ContentView()
        }
        detail: {
            DetailView()
        }
        .navigationSplitViewStyle(.balanced)
        .introspect(
            .navigationSplitView,
            on: .macOS(.v14, .v13),
            customize: { splitView in
                let splitViewItems: [NSSplitViewItem] = (splitView.delegate as? NSSplitViewController)?
                    .splitViewItems ?? []

                splitViewItems.first?.canCollapse = false
                splitViewItems.first?.isCollapsed = false

                if vm.selectedTab == .prompt {
                    splitViewItems[1].isCollapsed = true
                } else {
                    splitViewItems[1].isCollapsed = false
                }
            }
        )
        .frame(minWidth: 830,minHeight: 560)
    }
}

#Preview {
    AppView()
}
