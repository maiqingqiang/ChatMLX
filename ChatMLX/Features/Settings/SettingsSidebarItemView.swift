//
//  SettingsSidebarItemView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsSidebarItemView: View {
    @Environment(SettingsView.ViewModel.self) var settingsViewModel

    let tab: SettingsTab

    @State private var isHovering: Bool = false
    @State private var isActive: Bool = false
    @State private var showIndicator: Bool = false

    init(_ tab: SettingsTab) {
        self.tab = tab
    }

    var body: some View {
        HStack(spacing: 8) {
            tab.iconView()

            Text(LocalizedStringKey(tab.id.rawValue))

            if showIndicator {
                VStack {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 4, height: 4)
                        .padding(.top, 6)
                        .shadow(color: .red, radius: 4)

                    Spacer()
                }
            }

            Spacer()
        }
        .padding(4)
        .background {
            if isActive || isHovering {
                Rectangle().foregroundStyle(.quaternary.opacity(0.7))
            }
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            if isActive {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
        }
        .onHover { isHovering = $0 }
        .onAppear {
            checkIfSelfIsActiveTab()
            showIndicator = tab.showIndicator?(settingsViewModel) ?? false
        }
        .onChange(of: settingsViewModel.activeTabID) { _, _ in
            checkIfSelfIsActiveTab()
        }
        .onChange(of: tab.showIndicator?(settingsViewModel) ?? false) {
            _, newValue in
            withAnimation {
                showIndicator = newValue
            }
        }
        .listRowSeparator(.hidden)
    }

    func checkIfSelfIsActiveTab() {
        withAnimation(.easeOut(duration: 0.1)) {
            isActive = settingsViewModel.activeTabID == tab.id
        }
    }
}
