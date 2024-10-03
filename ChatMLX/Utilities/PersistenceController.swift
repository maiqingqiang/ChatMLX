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

    func exisits<T: NSManagedObject>(
        _ model: T,
        in context: NSManagedObjectContext
    ) -> T? {
        try? context.existingObject(with: model.objectID) as? T
    }

    func delete(_ model: some NSManagedObject) throws {
        if let existingContact = exisits(model, in: container.viewContext) {
            container.viewContext.delete(existingContact)
            Task(priority: .background) {
                try await container.viewContext.perform {
                    try container.viewContext.save()
                }
            }
        }
    }

    func clear(_ entityName: String) throws -> [NSManagedObjectID] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
            entityName: entityName)
        let batchDeteleRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeteleRequest.resultType = .resultTypeObjectIDs

        if let fetchResult = try container.viewContext.execute(batchDeteleRequest)
            as? NSBatchDeleteResult,
            let deletedManagedObjectIds = fetchResult.result as? [NSManagedObjectID],
            !deletedManagedObjectIds.isEmpty
        {
            return deletedManagedObjectIds
        }

        return []
    }

    func save() throws {
        Task(priority: .background) {
            let context = container.viewContext

            try await context.perform {
                if context.hasChanges {
                    try context.save()
                }
            }
        }
    }
}
