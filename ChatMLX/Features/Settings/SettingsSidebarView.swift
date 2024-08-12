//
//  SettingsSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsSidebarView: View {
    let titlebarHeight: CGFloat = 50
    let groupSpacing: CGFloat = 4
    let itemPadding: CGFloat = 12
    let groupTitlePadding: CGFloat = 4
    let itemSpacing: CGFloat = 4

    @Binding var activeTab: SettingsTab
    let tabs: [SettingsTab]
    let didTabChange: (SettingsTab) -> ()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.title2)
                .padding(.top, 50)
            Text("Preferences and model settings")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))

            ForEach(tabs) { tab in
                SettingsSidebarItemView(tab, $activeTab, didTabChange: didTabChange)
            }

            Spacer()
        }
        .padding(.horizontal, itemPadding)
        .background(.black.opacity(0.4))
    }
}

// #Preview {
//    SettingsSidebarView()
// }
#Preview {
    SettingsView()
}
