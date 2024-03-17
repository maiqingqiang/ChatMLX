//
//  SettingsView.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import Foundation
import SwiftUI

public struct SettingsView: View {
    @Environment(SettingsViewModel.self) private var vm

    static var pages: [SettingsPage] = [
        SettingsPage(name: .general, icon: .system("gear"), baseColor: .gray),
        SettingsPage(name: .models, icon: .system("shippingbox"), baseColor: .blue),
        SettingsPage(name: .huggingface, icon: .asset("huggingface"), baseColor: .yellow),
    ]

    @State private var selectedPage: SettingsPage = Self.pages.first!

    public init() {}

    @ViewBuilder
    func settingsItem(page: SettingsPage) -> some View {
        Label {
            Text(page.name.rawValue)
        } icon: {
            Group {
                switch page.icon {
                case .system(let name):
                    Image(systemName: name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .asset(let name):
                    Image(name, bundle: .main)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .none: EmptyView()
                }
            }
            .shadow(color: Color(NSColor.black).opacity(0.25), radius: 0.5, y: 0.5)
            .padding(2.5)
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill((page.baseColor ?? .white).gradient)
                .shadow(color: Color(NSColor.black).opacity(0.25), radius: 0.5, y: 0.5)
            )
        }
    }

    public var body: some View {
        NavigationSplitView {
            List(Self.pages, id: \.self, selection: $selectedPage) { page in
                settingsItem(page: page)
            }
            .navigationSplitViewColumnWidth(215)
        } detail: {
            Group {
                switch selectedPage.name {
                case .models:
                    ModelsSettingsView()
                        .navigationTitle(selectedPage.name.rawValue)
                case .huggingface:
                    HuggingfaceSettingsView()
                        .navigationTitle(selectedPage.name.rawValue)
                default:
                    Text("Implementation Needed").frame(alignment: .center)
                }
            }
        }
        .titlebarAppearsTransparentWithUnified("com_apple_SwiftUI_Settings_window")
    }
}

#Preview {
    SettingsView()
}
