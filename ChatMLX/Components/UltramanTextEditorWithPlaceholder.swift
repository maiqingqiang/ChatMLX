//
//  UltramanTextEditorWithPlaceholder.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/5.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String?

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(.top, 8)
                .padding(.leading, 5)
                .foregroundColor(text.isEmpty ? .clear : .white)
                .scrollContentBackground(.hidden)

            if text.isEmpty, let placeholder {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 8)
                    .padding(.leading, 12)
            }
        }
        .font(.body)
    }
}
