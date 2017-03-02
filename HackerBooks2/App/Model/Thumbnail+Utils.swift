//
//  Thumbnail+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Thumbnail{
    
    convenience init(book: Book, binary: NSData?, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Thumbnail.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.book = book
            self.binary = binary
            saveContext(context: context)
        }
        
    }
    
    class func get(book: Book, binary: NSData? = nil, context: NSManagedObjectContext?) -> Thumbnail{
        let fr = NSFetchRequest<Thumbnail>(entityName: Thumbnail.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Thumbnail.init(book: book, binary: binary, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Thumbnail.init(book: book, binary: binary, context: context!)
            }
        } catch{
            return Thumbnail.init(book: book, binary: binary, context: context!)
        }
    }
    
}
