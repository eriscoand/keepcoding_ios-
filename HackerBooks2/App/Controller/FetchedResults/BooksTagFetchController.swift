//
//  BooksTagFetchController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

func createBooksFetch(context: NSManagedObjectContext, text: String) -> NSFetchedResultsController<BookTag>{
    let _fetchedResultsController = NSFetchedResultsController(fetchRequest: BookTag.fetchRequest(text: text),
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: "tag.name",
                                                               cacheName: nil)
        
    do {
        try _fetchedResultsController.performFetch()
    } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    
    return _fetchedResultsController
}
