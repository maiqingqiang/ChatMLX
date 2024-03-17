//
//  ChatView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftData
import SwiftUI

public struct ChatView: View {
    public init() {}
    public var body: some View {
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
