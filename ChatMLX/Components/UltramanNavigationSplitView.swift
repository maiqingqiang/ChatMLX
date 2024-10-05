//
//  UltramanNavigationSplitView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftUI

struct UltramanNavigationTitleKey: PreferenceKey {
    static var defaultValue: LocalizedStringKey = ""

    static func reduce(
        value: inout LocalizedStringKey, nextValue: () -> LocalizedStringKey
    ) {
        value = nextValue()
    }
}

struct UltramanToolbarItem: Identifiable, Equatable {
    static func == (lhs: UltramanToolbarItem, rhs: UltramanToolbarItem) -> Bool {
        lhs.id == rhs.id && lhs.alignment == rhs.alignment
    }

    let id = UUID()
    let content: AnyView
    let alignment: ToolbarAlignment

    enum ToolbarAlignment {
        case leading, trailing
    }

    init(alignment: ToolbarAlignment = .trailing, @ViewBuilder content: () -> some View) {
        self.content = AnyView(content())
        self.alignment = alignment
    }
}

struct UltramanNavigationToolbarKey: PreferenceKey {
    static var defaultValue: [UltramanToolbarItem] = []

    static func reduce(
        value: inout [UltramanToolbarItem],
        nextValue: () -> [UltramanToolbarItem]
    ) {
        let newItems = nextValue()
        if !newItems.isEmpty {
            value.append(contentsOf: newItems)
        }
    }
}

@resultBuilder
struct UltramanToolbarBuilder {
    static func buildBlock(_ components: UltramanToolbarItem...) -> [UltramanToolbarItem] {
        components
    }
}

extension View {
    func ultramanNavigationTitle(_ title: LocalizedStringKey) -> some View {
        preference(key: UltramanNavigationTitleKey.self, value: title)
    }

    func ultramanToolbar(
        alignment: UltramanToolbarItem.ToolbarAlignment = .trailing,
        @ViewBuilder content: () -> some View
    ) -> some View {
        preference(
            key: UltramanNavigationToolbarKey.self,
            value: [
                UltramanToolbarItem(
                    alignment: alignment,
                    content: {
                        content()
                    }
                )
            ]
        )
    }

    func ultramanToolbar(
        @UltramanToolbarBuilder content: () -> [UltramanToolbarItem]
    ) -> some View {
        preference(
            key: UltramanNavigationToolbarKey.self,
            value: content()
        )
    }
}

struct UltramanNavigationSplitView<Sidebar: View, Detail: View>: View {
    @State var sidebarWidth: CGFloat = 250
    @State private var lastNonZeroWidth: CGFloat = 0
    let sidebar: () -> Sidebar
    let detail: () -> Detail

    @State private var navigationTitle: LocalizedStringKey = ""
    @State private var toolbarItems: [UltramanToolbarItem] = []

    @State private var isDragging = false
    @State private var isSidebarVisible = true

    let minSidebarWidth: CGFloat = 200
    let maxSidebarWidth: CGFloat = 400

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: .zero) {
                if isSidebarVisible {
                    sidebar()
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .leading))
                        .zIndex(10)
                }

                VStack(spacing: .zero) {
                    Divider()
                    detail()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onPreferenceChange(UltramanNavigationTitleKey.self) {
                            navigationTitle = $0
                        }
                        .onPreferenceChange(UltramanNavigationToolbarKey.self) {
                            toolbarItems = $0
                        }
                }

                .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                    header().frame(height: 52)
                }
            }
        }
    }

    @MainActor
    @ViewBuilder
    func header() -> some View {
        VStack(spacing: 0) {
            Spacer()

            HStack {
                if !isSidebarVisible {
                    Spacer()
                        .frame(width: 80)
                }

                Button {
                    toggleSidebar()
                } label: {
                    Image(systemName: "sidebar.leading")
                }
                .buttonStyle(.plain)

                ForEach(toolbarItems.filter { $0.alignment == .leading }) {
                    item in
                    item.content
                }

                Spacer()
                Text(navigationTitle)
                    .font(.headline)

                Spacer()

                ForEach(toolbarItems.filter { $0.alignment == .trailing }) {
                    item in
                    item.content
                }
            }
            .padding(.horizontal, 10)
            .padding(.trailing, 5)
            Spacer()
        }
        .frame(height: 50)
        .foregroundColor(.white)
    }

    func toggleSidebar() {
        withAnimation {
            if isSidebarVisible {
                lastNonZeroWidth = sidebarWidth
                sidebarWidth = 0
            } else {
                sidebarWidth = lastNonZeroWidth
            }
            isSidebarVisible.toggle()
        }
    }
}
