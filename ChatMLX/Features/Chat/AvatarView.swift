//
//  AvatarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

struct AvatarView: View {
    let role: Message.Role
    
    var body: some View {
        Image(systemName: role == .user ? "person.circle" : "brain.head.profile")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: 22)
            .foregroundColor(role == .user ? .blue : .green)
    }
}

#Preview {
    AvatarView(role: .assistant)
}
