//
//  RightSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/5.
//

import SwiftUI

struct RightSidebarView: View {
    @Binding var temperature: Double
    @Binding var topK: Double
    @Binding var maxLength: Double
    
    var body: some View {
        VStack {
            Text("Control").font(.headline)
            
            VStack(alignment: .leading) {
                Text("Temperature: \(temperature, specifier: "%.2f")")
                Slider(value: $temperature, in: 0...1)
                
                Text("Top K: \(Int(topK))")
                Slider(value: $topK, in: 1...100, step: 1)
                
                Text("Max Length: \(Int(maxLength))")
                Slider(value: $maxLength, in: 100...2000, step: 100)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .frame(width: 350)
        .background(.black.opacity(0.5))
//        .border(Color.gray, width: 0.5)
    }
}

// #Preview {
//    RightSidebarView()
// }
