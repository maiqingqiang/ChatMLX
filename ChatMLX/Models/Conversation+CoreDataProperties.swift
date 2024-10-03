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

extension Conversation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var title: String
    @NSManaged public var model: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var temperature: Float
    @NSManaged public var topP: Float
    @NSManaged public var useMaxLength: Bool
    @NSManaged public var maxLength: Int64
    @NSManaged public var repetitionContextSize: Int
    @NSManaged public var maxMessagesLimit: Int32
    @NSManaged public var useMaxMessagesLimit: Bool
    @NSManaged public var useRepetitionPenalty: Bool
    @NSManaged public var repetitionPenalty: Float
    @NSManaged public var useSystemPrompt: Bool
    @NSManaged public var systemPrompt: String
    @NSManaged public var promptTime: TimeInterval
    @NSManaged public var generateTime: TimeInterval
    @NSManaged public var promptTokensPerSecond: Double
    @NSManaged public var tokensPerSecond: Double
    @NSManaged public var messages: [Message]

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(Defaults[.defaultTitle], forKey: #keyPath(Conversation.title))
        setPrimitiveValue(Defaults[.defaultModel], forKey: #keyPath(Conversation.model))

        setPrimitiveValue(Defaults[.defaultTemperature], forKey: #keyPath(Conversation.temperature))
        setPrimitiveValue(Defaults[.defaultTopP], forKey: #keyPath(Conversation.topP))
        setPrimitiveValue(
            Defaults[.defaultRepetitionContextSize],
            forKey: #keyPath(Conversation.repetitionContextSize))

        setPrimitiveValue(
            Defaults[.defaultUseRepetitionPenalty],
            forKey: #keyPath(Conversation.useRepetitionPenalty))
        setPrimitiveValue(
            Defaults[.defaultRepetitionPenalty], forKey: #keyPath(Conversation.repetitionPenalty))

        setPrimitiveValue(
            Defaults[.defaultUseMaxLength], forKey: #keyPath(Conversation.useMaxLength))
        setPrimitiveValue(Defaults[.defaultMaxLength], forKey: #keyPath(Conversation.maxLength))
        setPrimitiveValue(
            Defaults[.defaultMaxMessagesLimit], forKey: #keyPath(Conversation.maxMessagesLimit))
        setPrimitiveValue(
            Defaults[.defaultUseMaxMessagesLimit],
            forKey: #keyPath(Conversation.useMaxMessagesLimit))

        setPrimitiveValue(
            Defaults[.defaultUseSystemPrompt], forKey: #keyPath(Conversation.useSystemPrompt))
        setPrimitiveValue(
            Defaults[.defaultSystemPrompt], forKey: #keyPath(Conversation.systemPrompt))

        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }

    public override func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }
}

// MARK: Generated accessors for messages

extension Conversation {
    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: Message, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [Message], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: Message)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [Message])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: [Message])

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: [Message])
}

extension Conversation: Identifiable {}
