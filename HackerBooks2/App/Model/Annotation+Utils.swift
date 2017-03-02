//
//  Annotation.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Annotation{
    
    convenience init (book: Book, title: String, text: String, page: Int16 = 0, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Book.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modifiedDate = NSDate()
        self.title = title
        self.text = text
        self.page = page
        
        saveContext(context: context)
        
    }
    
    class func get(id: NSManagedObjectID, book: Book, title: String = "", text: String = "", page: Int16 = 0, context: NSManagedObjectContext?) -> Annotation{
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "(objectId == %@)", title)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Annotation.init(book: book, title: title, text: text, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Annotation.init(book: book, title: title, text: text, context: context!)
            }
        } catch{
            return Annotation.init(book: book, title: title, text: text, context: context!)
        }
    }

    class func fetchController( book: Book, context: NSManagedObjectContext) -> NSFetchedResultsController<Annotation>{
        
        let frc = NSFetchedResultsController(fetchRequest: Annotation.fetchRequest(book: book),
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: "Annotation")
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc
    }
    
    
    class func fetchRequest(book: Book) -> NSFetchRequest<Annotation>{
        
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entity().name!)
        
        // Set the batch size to a suitable number.
        fr.fetchBatchSize = 20
        
        let bookPredicate = NSPredicate(format: "(book == %@)",book)
            
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate])
        fr.predicate = predicate
        
        fr.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: true),
                              NSSortDescriptor(key: "title", ascending: true)]
        
        return fr
        
    }
    
}
