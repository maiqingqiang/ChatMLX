//
//  Message+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//
//

import CoreData
import Foundation

extension Message {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var roleRaw: String

    public var role: Role {
        set {
            roleRaw = newValue.rawValue
        }
        get {
            Role(rawValue: roleRaw) ?? .assistant
        }
    }

    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var inferring: Bool
    @NSManaged public var updatedAt: Date
    @NSManaged public var error: String?
    @NSManaged public var conversation: Conversation

    public override func awakeFromInsert() {
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }

    public override func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }
}

extension Message: Identifiable {}
