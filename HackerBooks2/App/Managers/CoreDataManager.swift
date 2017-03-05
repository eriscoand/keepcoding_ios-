//
//  CoreDataManager.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import CoreData

public func persistentContainer(dbName: String, onError: ((NSError)->Void)? = nil) -> NSPersistentContainer {
    let container = NSPersistentContainer(name: dbName)
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError?, let onError = onError {
            onError(error)
        }
    })
    return container
}

//Mark Process to true if you want to process Pending changes
public func saveContext(context: NSManagedObjectContext, process: Bool = false) {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }    
    if(process){
        context.processPendingChanges()
    }
}

