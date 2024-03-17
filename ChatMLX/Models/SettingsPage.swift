//
//  SettingsPage.swift
//
//
//  Created by John Mai on 2024/3/16.
//
import Foundation
import SwiftUI

struct SettingsPage: Hashable, Equatable, Identifiable {
    let id: UUID = .init()

    enum Name: String {
        case general = "General"
        case models = "Models"
        case huggingface = "Huggingface"
    }

    enum IconResource: Equatable, Hashable {
        case system(_ name: String)
        case asset(_ name: String)
    }

    let name: Name
    let icon: IconResource?
    let baseColor: Color?
}
