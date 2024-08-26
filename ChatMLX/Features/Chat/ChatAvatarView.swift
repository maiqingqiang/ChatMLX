//
//  AvatarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

struct ChatAvatarView: View {
    let role: Message.Role
    
    var body: some View {
//        Image(systemName: role == .user ? "person.circle" : "brain.head.profile")
        Image("AppLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(role == .user ? .blue : .green)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .black.opacity(0.25), radius: 5, x: -1, y: 5)
    }
}

#Preview {
    ChatAvatarView(role: .assistant)
}
