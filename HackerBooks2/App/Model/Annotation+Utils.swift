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
    
    //Convenience init from book, title, text and page
    convenience init (book: Book, title: String, text: String, page: Int32 = 0, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modifiedDate = NSDate()
        self.title = title
        self.text = text
        self.page = page
        
        saveContext(context: context)
        
    }
    
    //Gets an Annotation from DB. If not exists it creates one. Searching by NSManagedObjectID
    class func get(id: NSManagedObjectID?, book: Book, title: String = "", text: String = "", page: Int16 = 0, context: NSManagedObjectContext?) -> Annotation{
        
        if (id == nil){
            return Annotation.init(book: book, title: title, text: text, context: context!)
        }
        
        if let obj = context?.object(with: id!) {
            return obj as! Annotation
        }else{
            return Annotation.init(book: book, title: title, text: text, context: context!)
        }
        
    }
    
    //Fetch Annotation Controller
    class func fetchController( book: Book, pageNumber: Int = 0, context: NSManagedObjectContext) -> NSFetchedResultsController<Annotation>{
        
        let frc = NSFetchedResultsController(fetchRequest: Annotation.fetchRequest(book: book, pageNumber: pageNumber),
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,  //NO section
                                             cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc
    }
    
    //Fetch Annotation Request. Searching by book and page number
    class func fetchRequest(book: Book, pageNumber: Int) -> NSFetchRequest<Annotation>{
        
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entity().name!)
        
        // Set the batch size to a suitable number.
        fr.fetchBatchSize = 20
        
        //Book predicate by default
        var bookPredicate = NSPredicate(format: "(book == %@)",book)
        
        //If the page number is set, search for the page number too
        if(pageNumber != 0){
            bookPredicate = NSPredicate(format: "(book == %@) and (page == %@)",book,pageNumber.description)
        }
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate])
        fr.predicate = predicate
        
        //Sorting
        fr.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false),
                              NSSortDescriptor(key: "title", ascending: true)]
        
        return fr
        
    }
    
}
