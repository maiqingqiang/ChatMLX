//
//  OpenAIProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import SwiftUI

struct OpenAIProvider: View {
    @State var isExpanded: Bool = false
    @State var isEnabled: Bool? = false

    var body: some View {
        ProviderView(isExpanded: $isExpanded, isEnabled: $isEnabled) {
            Label()
        } content: {
            Content()
        }
    }

    @ViewBuilder
    func Label() -> some View {
        HStack {
            Image("openai-logomark")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            Text("Other AI Provider")
        }
        .font(.title2.weight(.medium))
    }

    @ViewBuilder
    func Content() -> some View {
        VStack {
            Text("👋🏻 It will be supported soon ~ ")
                .font(.title2)
                .fontWeight(.medium)
            Text("🍻 If you have ideas, welcome to contribute.")
                .font(.subheadline)
        }
        .italic()
    }
}
