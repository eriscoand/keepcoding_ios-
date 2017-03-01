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
    
    class func fetchRequest(text: String) -> NSFetchRequest<BookTag>{
        
        let fetchRequest: NSFetchRequest<BookTag> = BookTag.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        if(text != ""){
            let t = text.lowercased()
            
            let orderPredicate = NSPredicate(format: "tag.order contains [cd] %@",t)
            let tagPredicate = NSPredicate(format: "tag.name contains [cd] %@",t)
            let bookPredicate = NSPredicate(format: "book.title contains [cd] %@",t)
            let authorPredicate = NSPredicate(format: "book.authors.name contains [cd] %@",t)
                
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [orderPredicate,tagPredicate,bookPredicate,authorPredicate])
                
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tag.order", ascending: true),
                                        NSSortDescriptor(key: "tag.name", ascending: true),
                                        NSSortDescriptor(key: "book.title", ascending: true)]
        
        
        return fetchRequest
        
    }
    
    class func booktagFromBookTag(book: Book, tag: Tag, context: NSManagedObjectContext?) -> BookTag {
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "book == %@ and tag = %@", book, tag)
        
        do{
            let rows = try context?.fetch(fr)
            if let r = rows{
                if r.count > 0{
                    return r.first!
                }
            }
        }catch{
            //TODO
        }
        
        let booktag = BookTag(context: context!)
        booktag.book = book
        booktag.tag = tag
        
        return booktag
        
    }
    
}
