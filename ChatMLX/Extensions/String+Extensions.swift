//
//  String+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
