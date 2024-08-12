
//
//  SettingsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsView: View {
    @State private var sidebarWidth: CGFloat = 200
    @State private var activeTab: SettingsTab
    let tabs: [SettingsTab] = [
        .init("Models", Image(systemName: "brain"), ModelsView()),
        .init("MLX Community", Image("mlx-logo-2"), MLXCommunityView()),
        .init("Download Manager", Image(systemName: "arrow.down.circle"), DownloadManagerView()),
        .init("About", Image(systemName: "info.circle"), AboutView()),
    ]

    init() {
        self.activeTab = tabs.first!
    }

    var body: some View {
        UltramanNavigationSplitView(sidebarWidth: $sidebarWidth) {
            SettingsSidebarView(activeTab: $activeTab, tabs: tabs) { tab in
                print(tab)
            }
        } detail: {
            activeTab.view
        }
        .ultramanMinimalistWindowStyle()
        .frame(width: 600, height: 500)
        .foregroundColor(.white)
    }
}

#Preview {
    SettingsView()
}
