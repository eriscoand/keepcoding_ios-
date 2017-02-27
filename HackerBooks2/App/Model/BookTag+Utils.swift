//
//  BookTag+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 26/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension BookTag{
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<BookTag>{
        
        let fetchRequest: NSFetchRequest<BookTag> = BookTag.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tag.name", ascending: true),
                                        NSSortDescriptor(key: "book.title", ascending: true)]
        
        return fetchRequest
        
    }
    
}
