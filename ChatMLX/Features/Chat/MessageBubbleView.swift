//
//  MessageBubbleView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

// import SwiftUI
//
// struct MessageBubbleView: View {
//    let message: Message
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack(alignment: .top, spacing: 12) {
//                AvatarView(role: message.role)
//
//                Text(message.content)
//                    .font(.body)
//                    .fixedSize(horizontal: false, vertical: true)
//
//                Spacer()
//            }
//        }
//        .padding(.vertical, 8)
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter.string(from: date)
//    }
// }
//
// #Preview {
//    MessageBubbleView(message: Message(role: .user, content: "Hi!"))
// }
import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .assistant {
                assistantMessageView
            } else {
                Spacer()
                userMessageView
            }
        }
        .padding(.vertical, 8)
    }
    
    private var assistantMessageView: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(role: .assistant)
            
            Text(message.content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                
            Spacer()
        }
    }
    
    private var userMessageView: some View {
        Text(message.content)
            .padding(10)
            .background(Color.black.opacity(0.1618))
            .foregroundColor(.white)
            .cornerRadius(15)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    VStack {
        MessageBubbleView(message: Message(role: .user, content: "Hi!"))
        MessageBubbleView(message: Message(role: .assistant, content: "Hello! How can I help you today?"))
    }
}
