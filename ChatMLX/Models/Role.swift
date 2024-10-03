//
//  Role.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/3.
//

public enum Role: String, Codable {
    case user
    case assistant
    case system

    var description: String {
        "\(self)"
    }
}
