//
//  UltramanTextEditor.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/5.
//
import SwiftUI

struct UltramanTextEditor: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()

        let textView = scrollView.documentView as! NSTextView
        textView.delegate = context.coordinator
        textView.isRichText = false
        textView.font = .systemFont(ofSize: NSFont.systemFontSize)
        textView.backgroundColor = .clear
        textView.drawsBackground = false
        textView.textColor = .white
        context.coordinator.setupPlaceholder(for: textView)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            textView.string = text
        }

        context.coordinator.updatePlaceholder(for: textView)

        let extraHeight: CGFloat = 50
        let contentSize = textView.string.boundingRect(
            with: textView.frame.size, options: .usesLineFragmentOrigin,
            attributes: [.font: textView.font!]
        ).size
        textView.minSize = NSSize(
            width: 0, height: contentSize.height + extraHeight
        )
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: UltramanTextEditor
        var placeholderView: NSTextView?

        init(_ parent: UltramanTextEditor) {
            self.parent = parent
            super.init()
        }

        func setupPlaceholder(for textView: NSTextView) {
            let placeholder = NSTextView(frame: textView.bounds)
            placeholder.isSelectable = false
            placeholder.backgroundColor = .clear
            placeholder.textColor = .white.withAlphaComponent(0.7)
            placeholder.font = textView.font
            placeholder.string = parent.placeholder
            placeholder.alignment = .left
            placeholder.textContainerInset = NSSize(width: 6, height: 0)

            textView.addSubview(placeholder)
            placeholderView = placeholder

            updatePlaceholder(for: textView)
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            parent.text = textView.string
            updatePlaceholder(for: textView)
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            updatePlaceholder(for: textView)
        }

        func textView(
            _ textView: NSTextView, doCommandBy commandSelector: Selector
        ) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                if NSEvent.modifierFlags.contains(.shift) {
                    textView.insertNewlineIgnoringFieldEditor(nil)
                    return true
                } else {
                    parent.onSubmit()
                    return true
                }
            }
            return false
        }

        func updatePlaceholder(for textView: NSTextView) {
            placeholderView?.isHidden =
                !textView.string.isEmpty || textView.selectedRange().length > 0
        }
    }
}
