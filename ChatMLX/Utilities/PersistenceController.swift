//
//  Persistence.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ChatMLX")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func exisits<T: NSManagedObject>(_ model: T,
                                     in context: NSManagedObjectContext) -> T?
    {
        try? context.existingObject(with: model.objectID) as? T
    }

    func delete(_ model: some NSManagedObject,
                in context: NSManagedObjectContext) throws
    {
        if let existingContact = exisits(model, in: context) {
            context.delete(existingContact)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }

    func clear(_ entityName: String) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let batchDeteleRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeteleRequest.resultType = .resultTypeObjectIDs

        if let fetchResult = try container.viewContext.execute(batchDeteleRequest) as? NSBatchDeleteResult,
           let deletedManagedObjectIds = fetchResult.result as? [NSManagedObjectID], !deletedManagedObjectIds.isEmpty
        {
            let changes = [NSDeletedObjectsKey: deletedManagedObjectIds]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func save() throws {
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
    }
    
    func createConversation() throws -> Conversation {
        let conversation = Conversation(context: container.viewContext)
        try save()
        return conversation
    }
    
    func clearConversation() throws {
        try clear("Conversation")
    }
    
    func clearMessage() throws {
        try clear("Message")
    }
}
