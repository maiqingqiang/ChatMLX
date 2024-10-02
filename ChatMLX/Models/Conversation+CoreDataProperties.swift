//
//  Conversation+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//
//

import CoreData
import Defaults
import Foundation

public extension Conversation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Conversation> {
        NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged var title: String
    @NSManaged var model: String
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var temperature: Float
    @NSManaged var topP: Float
    @NSManaged var useMaxLength: Bool
    @NSManaged var maxLength: Int64
    @NSManaged var repetitionContextSize: Int32
    @NSManaged var maxMessagesLimit: Int32
    @NSManaged var useMaxMessagesLimit: Bool
    @NSManaged var useRepetitionPenalty: Bool
    @NSManaged var repetitionPenalty: Float
    @NSManaged var useSystemPrompt: Bool
    @NSManaged var systemPrompt: String
    @NSManaged var promptTime: Double
    @NSManaged var generateTime: Double
    @NSManaged var promptTokensPerSecond: Double
    @NSManaged var tokensPerSecond: Double
    @NSManaged var messages: [Message]

    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(Defaults[.defaultTitle], forKey: #keyPath(Conversation.title))
        setPrimitiveValue(Defaults[.defaultModel], forKey: #keyPath(Conversation.model))

        setPrimitiveValue(Defaults[.defaultTemperature], forKey: #keyPath(Conversation.temperature))
        setPrimitiveValue(Defaults[.defaultTopP], forKey: #keyPath(Conversation.topP))
        setPrimitiveValue(Defaults[.defaultRepetitionContextSize], forKey: #keyPath(Conversation.repetitionContextSize))

        setPrimitiveValue(Defaults[.defaultUseRepetitionPenalty], forKey: #keyPath(Conversation.useRepetitionPenalty))
        setPrimitiveValue(Defaults[.defaultRepetitionPenalty], forKey: #keyPath(Conversation.repetitionPenalty))

        setPrimitiveValue(Defaults[.defaultUseMaxLength], forKey: #keyPath(Conversation.useMaxLength))
        setPrimitiveValue(Defaults[.defaultMaxLength], forKey: #keyPath(Conversation.maxLength))
        setPrimitiveValue(Defaults[.defaultMaxMessagesLimit], forKey: #keyPath(Conversation.maxMessagesLimit))
        setPrimitiveValue(Defaults[.defaultUseMaxMessagesLimit], forKey: #keyPath(Conversation.useMaxMessagesLimit))

        setPrimitiveValue(Defaults[.defaultUseSystemPrompt], forKey: #keyPath(Conversation.useSystemPrompt))
        setPrimitiveValue(Defaults[.defaultSystemPrompt], forKey: #keyPath(Conversation.systemPrompt))

        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }

    override func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }
}

// MARK: Generated accessors for messages

public extension Conversation {
    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged func insertIntoMessages(_ value: Message, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged func insertIntoMessages(_ values: [Message], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged func replaceMessages(at idx: Int, with value: Message)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged func replaceMessages(at indexes: NSIndexSet, with values: [Message])

    @objc(addMessagesObject:)
    @NSManaged func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged func addToMessages(_ values: [Message])

    @objc(removeMessages:)
    @NSManaged func removeFromMessages(_ values: [Message])
}

extension Conversation: Identifiable {}
