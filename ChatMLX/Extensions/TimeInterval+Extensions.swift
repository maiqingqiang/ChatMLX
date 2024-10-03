//
//  TimeInterval+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/3.
//

import Foundation

extension TimeInterval {
    func formatted(
        allowedUnits: NSCalendar.Unit = [.hour, .minute, .second],
        unitsStyle: DateComponentsFormatter.UnitsStyle = .abbreviated,
        includingMilliseconds: Bool = true
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.unitsStyle = unitsStyle

        var formattedString = formatter.string(from: self) ?? ""

        if includingMilliseconds {
            let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            formattedString += String(format: " %03dms", milliseconds)
        }

        return formattedString
    }
}
