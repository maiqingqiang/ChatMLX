//
//  ContentView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    private var fullScreenPresentationWindowDelegate = FullScreenPresentationWindowDelegate()

    var body: some View {
        ChatView()
            .ultramanMinimalistWindowStyle()
            .frame(minWidth: 900, minHeight: 580)
    }
}

#Preview {
    ContentView()
}
