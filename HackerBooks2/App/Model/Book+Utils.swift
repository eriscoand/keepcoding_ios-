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
    
    convenience init (title: String, thumbnailUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Book.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.pdfUrl = pdfUrl
        
        saveContext(context: context)
        
    }
    
    class func get(title: String, thumbnailUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext?) -> Book{
        let fr = NSFetchRequest<Book>(entityName: Book.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "(title == %@)", title)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Book.init(title: title, thumbnailUrl: thumbnailUrl, pdfUrl: pdfUrl, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Book.init(title: title, thumbnailUrl: thumbnailUrl, pdfUrl: pdfUrl, context: context!)
            }
        } catch{
            return Book.init(title: title, thumbnailUrl: thumbnailUrl, pdfUrl: pdfUrl, context: context!)
        }
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
    
    class func from(array arr: [Book]) -> Set<Book>{
        var ret = Set<Book>()
        
        for book in arr{
            ret.insert(book)
        }
        
        return ret
    }
    
    class func setIsFavourite(book: Book, context: NSManagedObjectContext) -> Book{
        
        let tag = Tag.get(name: CONSTANTS.FavouritesName, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        book.isFavourite = !book.isFavourite
        
        if(!book.isFavourite){
            context.delete(booktag)
        }
        
        return book
        
    }

    
}
