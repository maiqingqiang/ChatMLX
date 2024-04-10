//
//  TextEditorWithPlaceholder.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/7.
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
                .foregroundColor(text.isEmpty ? .clear : .primary)

            if text.isEmpty, let placeholder {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 10)
            }
        }
        .font(.body)
    }
}
