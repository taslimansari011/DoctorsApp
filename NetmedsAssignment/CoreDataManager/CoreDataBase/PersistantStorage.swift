//
//  PersistantStorage.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation
import CoreData

final class PersistentStorage {
    
    static var shared = PersistentStorage()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NetmedsAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext () {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            return try context.fetch(T.fetchRequest()) as? [T]
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}


