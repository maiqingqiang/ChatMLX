//
//  ErrorAlertModifier.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/3.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var showErrorAlert: Bool
    @Binding var errorTitle: String?
    @Binding var error: Error?

    func body(content: Content) -> some View {
        content
            .alert(
                errorTitle ?? "Error", isPresented: $showErrorAlert,
                actions: {
                    Button("OK") {
                        error = nil
                    }

                    Button("Feedback") {
                        error = nil
                        NSWorkspace.shared.open(
                            URL(string: "https://github.com/maiqingqiang/ChatMLX/issues")!)
                    }
                },
                message: {
                    Text(error?.localizedDescription ?? "An unknown error occurred.")
                })
    }
}

extension View {
    func errorAlert(isPresented: Binding<Bool>, title: Binding<String?>, error: Binding<Error?>)
        -> some View
    {
        modifier(ErrorAlertModifier(showErrorAlert: isPresented, errorTitle: title, error: error))
    }
}
