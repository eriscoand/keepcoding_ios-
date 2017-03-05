//
//  Pdf+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Pdf{
    
    //Convenience init from book, data and number of pages
    convenience init(book: Book, binary: NSData?, numberOfPages: Int? = 0, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.book = book
            self.binary = binary
            self.numberOfPages = Int32(numberOfPages!)
            saveContext(context: context)
        }
        
    }
    
    //Gets a PDF from DB. If not exists it creates one
    class func get(book: Book, binary: NSData? = nil, numberOfPages: Int? = 0, context: NSManagedObjectContext?) -> Pdf{
        let fr = NSFetchRequest<Pdf>(entityName: Pdf.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Pdf.init(book: book, binary: binary, numberOfPages: numberOfPages, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Pdf.init(book: book, binary: binary, numberOfPages: numberOfPages, context: context!)
            }
        } catch{
            return Pdf.init(book: book, binary: binary, numberOfPages: numberOfPages, context: context!)
        }
    }
    
}
