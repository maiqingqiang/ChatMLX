//
//  SettingsSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsSidebarView: View {
    @Environment(SettingsViewModel.self) var settingsViewModel

    let titlebarHeight: CGFloat = 50
    let groupSpacing: CGFloat = 4
    let itemPadding: CGFloat = 15
    let groupTitlePadding: CGFloat = 4
    let itemSpacing: CGFloat = 4

    static let tabs: [SettingsTab] = [
        .init(.general, Image(systemName: "gearshape")),
        .init(.defaultConversation, Image(systemName: "person.bubble")),
        .init(.huggingFace, Image("huggingface")),
        .init(.models, Image(systemName: "brain")),
        .init(.mlxCommunity, Image("MLX")),
        .init(
            .downloadManager, Image(systemName: "arrow.down.circle"),
            showIndicator: { $0.tasks.contains { $0.isDownloading } }
        ),
        .init(.experimentalFeatures, Image(systemName: "flask")),
        .init(.about, Image(systemName: "info.circle")),
    ]

    var body: some View {
        @Bindable var settingsViewModel = settingsViewModel
        VStack(alignment: .leading) {
            Group {
                Text("Settings")
                    .font(.title2)
                    .padding(.top, 50)
                Text("Preferences and model settings")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, itemPadding)

            List(selection: $settingsViewModel.activeTabID) {
                ForEach(Self.tabs) { tab in
                    SettingsSidebarItemView(tab)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)

            Spacer()
        }
        .background(.black.opacity(0.4))
    }
}

#Preview {
    SettingsView()
}
