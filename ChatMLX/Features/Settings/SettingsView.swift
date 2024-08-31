//
//  SettingsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsView.ViewModel.self) var settingsViewModel

    var body: some View {
        @Bindable var settingsViewModel = settingsViewModel

        UltramanNavigationSplitView(sidebarWidth: 210) {
            SettingsSidebarView()
        } detail: {
            Group {
                switch settingsViewModel.activeTabID {
                case .general:
                    GeneralView()
                case .defaultConversation:
                    DefaultConversationView()
                case .huggingFace:
                    HuggingFaceView()
                case .models:
                    LocalModelsView()
                case .downloadManager:
                    DownloadManagerView()
                case .mlxCommunity:
                    MLXCommunityView()
                case .about:
                    AboutView()
                }
            }
        }
        .ultramanMinimalistWindowStyle()
        .foregroundColor(.white)
    }
}

extension SettingsView {
    @Observable
    class ViewModel {
        var tasks: [DownloadTask] = []
        var sidebarWidth: CGFloat = 250
        var activeTabID: SettingsTab.ID = .general
        var remoteModels: [RemoteModel] = []
    }
}

#Preview {
    SettingsView()
        .environment(SettingsView.ViewModel())
}
