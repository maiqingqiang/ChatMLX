//
//  SettingsTab.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsTab: Identifiable, Equatable {
    public static func == (lhs: SettingsTab, rhs: SettingsTab) -> Bool {
        rhs.id == lhs.id
    }
    
    enum ID:String {
        case general = "General"
        case defaultConversation = "Default Conversation"
        case huggingFace = "Hugging Face"
        case models = "Models"
        case mlxCommunity = "MLX Community"
        case downloadManager = "Download Manager"
        case about = "About"
    }

    let id: ID
    let icon: Image
    let showIndicator: ((SettingsView.ViewModel) -> Bool)?

    init(_ id: ID, _ icon: Image, showIndicator: ((SettingsView.ViewModel) -> Bool)? = nil) {
        self.id = id
        self.icon = icon
        self.showIndicator = showIndicator
    }

    func iconView() -> some View {
        Rectangle()
            .opacity(0)
            .overlay {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(10)
            .fixedSize()
            .background(.quinary)
            .clipShape(.rect(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
    }
}
