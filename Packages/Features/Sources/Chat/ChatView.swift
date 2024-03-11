//
//  ChatView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

public struct ChatView: View {
    @Environment(ChatViewModel.self) private var vm

    public init() {}

    public var body: some View {
        @Bindable var vm = vm
        NavigationSplitView {
           SidebarView()
        } detail: {
            DetailView()
        }
    }
}

#Preview {
    ChatView()
}
