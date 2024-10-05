//
//  Binding+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//

import Foundation
import SwiftUI

extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

extension Binding {
    func asDouble() -> Binding<Double> where Value: BinaryInteger {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Value($0) }
        )
    }
}
