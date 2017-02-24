//
//  Book+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 24/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    class func fetchRequestOrderedByName() -> NSFetchRequest<Book>{
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
        
    }
}
