//
//  UltramanTextField.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/18.
//

import SwiftUI

public struct UltramanSecureField: View {
    let elementMinHeight: CGFloat = 34
    let horizontalPadding: CGFloat = 8

    @Binding var text: String
    let title: LocalizedStringKey
    let placeholder: Text?
    let onSubmit: (() -> Void)?
    var alignment: Alignment = .leading

    @State var monitor: Any?
    @State private var isFocused: Bool = false

    public init(
        _ text: Binding<String>,
        title: LocalizedStringKey = "",
        placeholder: Text?,
        onSubmit: (() -> Void)? = nil,
        alignment: Alignment = .leading
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.alignment = alignment
    }

    public var body: some View {
        ZStack(alignment: alignment) {
            if !isFocused, text.isEmpty, let placeholder {
                placeholder
                    .foregroundColor(.white.opacity(0.7))
                    .padding(alignment == .leading ? .leading : .trailing, 10)
            }

            SecureField(title, text: $text)
                .padding(.horizontal, horizontalPadding)
                .frame(minHeight: elementMinHeight)
                .multilineTextAlignment(
                    alignment == .leading ? .leading : .trailing
                )
                .textFieldStyle(.plain)
                .onSubmit {
                    if let onSubmit {
                        onSubmit()
                    }
                }
                .onAppear {
                    guard monitor != nil else { return }

                    monitor = NSEvent.addLocalMonitorForEvents(
                        matching: .keyDown
                    ) {
                        event in
                        if let window = NSApp.keyWindow,
                            window.animationBehavior == .documentWindow
                        {
                            window.keyDown(with: event)

                            // Fixes cmd+w to close window.
                            let wKey = 13
                            if event.keyCode == wKey,
                                event.modifierFlags.contains(.command)
                            {
                                return nil
                            }
                        }
                        return event
                    }
                }
                .onDisappear {
                    if let monitor {
                        NSEvent.removeMonitor(monitor)
                    }
                    monitor = nil
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: NSControl.textDidBeginEditingNotification)
                ) { _ in
                    isFocused = true
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: NSControl.textDidEndEditingNotification)
                ) { _ in
                    isFocused = false
                }
        }
    }
}
