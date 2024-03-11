//
//  SwiftUIView.swift
//
//
//  Created by John Mai on 2024/3/11.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(nsImage: NSImage(resource: ImageResource(name: "logo", bundle: .main)))
                .resizable()
                .frame(width: 64, height: 64)
            Text("How can I help you today?")
                .font(.title)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView()
}
