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
    
    class func bookFromTitle(title: String, context: NSManagedObjectContext?) -> Book {
        
        let bookTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fr = NSFetchRequest<Book>(entityName: Book.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "title == %@", bookTitle)
        
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
        
        let book = Book(context: context!)
        book.title = bookTitle
        
        saveContext(context: context!)
        
        return book
    
    }
    
    class func from(array arr: [Book]) -> Set<Book>{
        var ret = Set<Book>()
        
        for book in arr{
            ret.insert(book)
        }
        
        return ret
    }
    
    var authorsString : String{
        get{
            var ret = ""
            for author in authors!{
                ret += (author as AnyObject).name + " - "
            }
            return ret
        }
    }
}
