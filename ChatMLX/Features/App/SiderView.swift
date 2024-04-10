//
//  SiderView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
//

import SwiftUI

struct SiderView: View {
    @Environment(AppViewModel.self) private var vm
    @Namespace var animation
    let featrues: [Featrue] = [
        Featrue(name: .prompt, icon: "sparkles"),
        Featrue(name: .chat, icon: "message"),
    ]

    var body: some View {
        VStack(spacing: 16) {
            Image("logo", bundle: .main)
                .resizable()
                .frame(width: 50, height: 50)
                .shadow(color: .gray.opacity(0.3), radius: 1)

            ForEach(featrues) { featrue in
                Tab(featrue)
            }

            Spacer()

            Setting
        }
        .padding(.vertical)
        .buttonStyle(BorderlessButtonStyle())
        .toolbar(removing: .sidebarToggle)
        .navigationSplitViewColumnWidth(65)
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    var Setting: some View {
        SettingsLink {
            Image(systemName: "gear")
        }
        .buttonStyle(SidebarButtonStyle())
        .help("Settings")
    }

    @ViewBuilder
    func Tab(_ featrue: Featrue) -> some View {
        Image(systemName: featrue.icon)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(vm.selectedTab == featrue.name ? .black : .gray)
            .frame(width: 28, height: 28)
            .frame(width: 65, height: 50)
            .overlay(
                HStack {
                    if vm.selectedTab == featrue.name {
                        Capsule().fill(.black)
                            .frame(width: 2, height: 40)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                },
                alignment: .trailing
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring) {
                    vm.switchTab(featrue)
                }
            }
            .help(featrue.name.rawValue)
    }
}

#Preview {
    SiderView()
}
