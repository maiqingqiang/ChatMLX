//
//  UltramanNavigationSplitView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftUI

struct UltramanNavigationTitleModifier: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        content
            .preference(key: UltramanNavigationTitleKey.self, value: title)
    }
}

struct UltramanNavigationTitleKey: PreferenceKey {
    static var defaultValue: String = ""

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct UltramanToolbarItem: Identifiable, Equatable {
    static func == (lhs: UltramanToolbarItem, rhs: UltramanToolbarItem) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let content: AnyView
    let alignment: ToolbarAlignment

    enum ToolbarAlignment {
        case leading, trailing
    }
}

struct UltramanNavigationToolbarModifier: ViewModifier {
    let items: [UltramanToolbarItem]

    func body(content: Content) -> some View {
        content
            .preference(key: UltramanNavigationToolbarKey.self, value: items)
    }
}

struct UltramanNavigationToolbarKey: PreferenceKey {
    static var defaultValue: [UltramanToolbarItem] = []

    static func reduce(value: inout [UltramanToolbarItem], nextValue: () -> [UltramanToolbarItem]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    func ultramanNavigationTitle(_ title: String) -> some View {
        modifier(UltramanNavigationTitleModifier(title: title))
    }

    func ultramanToolbarItem(alignment: UltramanToolbarItem.ToolbarAlignment = .trailing, @ViewBuilder content: () -> some View) -> some View {
        let item = UltramanToolbarItem(content: AnyView(content()), alignment: alignment)
        return modifier(UltramanNavigationToolbarModifier(items: [item]))
    }
}

struct UltramanNavigationSplitView<Sidebar: View, Detail: View>: View {
    @Binding var sidebarWidth: CGFloat
    @State private var lastNonZeroWidth: CGFloat = 0
    let minSidebarWidth: CGFloat = 200
    let maxSidebarWidth: CGFloat = 300
    let sidebar: () -> Sidebar
    let detail: () -> Detail

    @State private var navigationTitle: String = ""
    @State private var toolbarItems: [UltramanToolbarItem] = []

    @State private var isDragging = false
    @State private var isSidebarVisible = true

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 0) {
                if isSidebarVisible {
                    ZStack(alignment: .trailing) {
                        sidebar()
                            .frame(width: max(sidebarWidth, 0))

                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 4)
                            .onHover { inside in
                                if inside {
                                    NSCursor.resizeLeftRight.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newWidth = sidebarWidth + value.translation.width
                                        sidebarWidth = min(max(newWidth, minSidebarWidth), maxSidebarWidth)
                                    }
                            )
                    }
                    .transition(.move(edge: .leading))
                }

                VStack(spacing: 0) {
                    Divider()
                    detail()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onPreferenceChange(UltramanNavigationTitleKey.self) { title in
                            navigationTitle = title
                        }
                        .onPreferenceChange(UltramanNavigationToolbarKey.self) { items in
                            toolbarItems = items
                        }
                }
                .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                    header().frame(height: 52)
                }
            }
        }
    }

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
                }.buttonStyle(.plain)

                ForEach(toolbarItems.filter { $0.alignment == .leading }) { item in
                    item.content
                }

                Spacer()
                Text(navigationTitle)
                    .font(.headline)

                Spacer()

                ForEach(toolbarItems.filter { $0.alignment == .trailing }) { item in
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
