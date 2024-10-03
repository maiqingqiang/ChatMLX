//
//  Message+CoreDataClass.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//
//

import CoreData
import Foundation

@objc(Message)
public class Message: NSManagedObject {
    @discardableResult
    func user(content: String, conversation: Conversation?) -> Self {
        self.role = .user
        self.content = content
        if let conversation {
            self.conversation = conversation
        }
        return self
    }

    @discardableResult
    func assistant(conversation: Conversation?) -> Self {
        self.role = .assistant
        self.inferring = true
        self.content = ""
        if let conversation {
            self.conversation = conversation
        }
        return self
    }

    func format() -> [String: String] {
        [
            "role": self.roleRaw,
            "content": self.content,
        ]
    }
}
