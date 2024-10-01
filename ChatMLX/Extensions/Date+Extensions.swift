//
//  Date+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/1.
//

import Foundation

extension Date {
    func toFormattedString(style: DateFormatter.Style = .medium, locale: Locale = .current)
        -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = style
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
