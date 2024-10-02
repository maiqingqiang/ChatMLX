//
//  Message+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//
//

import CoreData
import Foundation

public extension Message {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Message> {
        NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged var role: String
    @NSManaged var content: String
    @NSManaged var createdAt: Date
    @NSManaged var inferring: Bool
    @NSManaged var updatedAt: Date
    @NSManaged var error: String?
    @NSManaged var conversation: Conversation
    
    override func awakeFromInsert() {
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }

    override func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }
}

extension Message: Identifiable {}
