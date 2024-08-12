//
//  SettingsTab.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

public struct SettingsTab: Identifiable, Equatable {
    public static func == (lhs: SettingsTab, rhs: SettingsTab) -> Bool {
        rhs.id == lhs.id
    }

    public var id: UUID = .init()

    public let title: LocalizedStringKey
    public let icon: Image
    public let view: AnyView
    public let showIndicator: (() -> Bool)?

    public init(_ title: LocalizedStringKey, _ icon: Image, _ view: some View, showIndicator: (() -> Bool)? = nil) {
        self.title = title
        self.icon = icon
        self.view = AnyView(view)
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
