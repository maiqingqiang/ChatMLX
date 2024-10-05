//
//  ProviderView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import SwiftUI

struct ProviderView<Label: View, Content: View>: View {
    @Binding var isExpanded: Bool
    @Binding var isEnabled: Bool?
    @ViewBuilder let label: () -> Label
    @ViewBuilder let content: () -> Content

    let cornerRadius: CGFloat = 12

    var body: some View {
        VStack(spacing: 0) {
            header
            if isExpanded {
                content()
                    .padding()
            }
        }
        .background(.quinary)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(.quaternary, lineWidth: 1)
        }
    }

    @MainActor
    @ViewBuilder
    private var header: some View {
        HStack {
            Image(systemName: "chevron.down")
                .font(.title3.weight(.semibold))
                .rotationEffect(.degrees(isExpanded ? -180 : 0))

            label()

            Spacer()

            if isEnabled != nil {
                Toggle("", isOn: $isEnabled.toUnwrapped(defaultValue: false))
                    .labelsHidden()
                    .toggleStyle(.switch)
            }
        }
        .padding(.horizontal)
        .frame(height: 45)
        .background(Color.black.opacity(0.1))
        .onTapGesture {
            withAnimation(.easeIn) {
                isExpanded.toggle()
            }
        }
        .zIndex(10)
        .transition(.move(edge: .top))
    }
}
