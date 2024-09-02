//
//  AboutView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import Luminare
import SwiftUI

struct AboutView: View {
    @State private var isCheckingUpdate = false

    var body: some View {
        VStack(spacing: 30) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)

            Text("ChatMLX")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")"
            )
            .font(.subheadline)
            .foregroundColor(.white)

            Link("GitHub", destination: URL(string: "https://github.com/maiqingqiang/ChatMLX")!)
                .font(.headline)
                .foregroundColor(.blue.opacity(0.8))

            Spacer()
            LuminareSection {
                Button(action: {
                    isCheckingUpdate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isCheckingUpdate = false
                    }

                    NSWorkspace.shared.open(URL(string: "https://github.com/maiqingqiang/ChatMLX")!)
                }) {
                    Text(isCheckingUpdate ? "Checking..." : "Check for updates")
                }
                .frame(height: 30)
                .buttonStyle(LuminareButtonStyle())
                .disabled(isCheckingUpdate)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ultramanNavigationTitle("About")
    }
}
