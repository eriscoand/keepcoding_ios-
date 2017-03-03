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
    
    convenience init(book: Book, tag: Tag, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.book = book
        self.tag = tag
        
    }
    
    class func get(book: Book, tag: Tag, context: NSManagedObjectContext?) -> BookTag{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "(book == %@) and (tag = %@)", book, tag)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return BookTag.init(book: book, tag: tag, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return BookTag.init(book: book, tag: tag, context: context!)
            }
        } catch{
            return BookTag.init(book: book, tag: tag, context: context!)
        }
    }
    
    
    class func getLastOpened(context: NSManagedObjectContext) -> BookTag?{
        return UserDefaults.loadBookLastOpen(context: context)
    }
    
    class func setLastOpened(booktag: BookTag, context: NSManagedObjectContext){
        
        let tag = Tag.get(name: (booktag.tag?.name)!, context: context)
        let book = Book.get(title: (booktag.book?.title)!, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        UserDefaults.saveBookTagLastOpen(booktag: booktag)
        
    }
    
    class func archiveUriFrom(booktag: BookTag) -> Data? {
        let uri = booktag.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri)
    }
    
    class func bookTagFrom(archivedURI: Data, context: NSManagedObjectContext) -> BookTag? {
        
        if let uri: URL = NSKeyedUnarchiver.unarchiveObject(with: archivedURI) as? URL, let nid = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            let booktag = context.object(with: nid) as! BookTag
            return booktag
        }
        
        return nil
    }
    
    class func fetchController(context: NSManagedObjectContext, text: String) -> NSFetchedResultsController<BookTag>{
        
        let frc = NSFetchedResultsController(fetchRequest: BookTag.fetchRequest(text: text),
                                            managedObjectContext: context,
                                            sectionNameKeyPath: "tag.proxyForSorting",
                                            cacheName: "BookTag")
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc
    }

    
    class func fetchRequest(text: String) -> NSFetchRequest<BookTag>{
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        
        // Set the batch size to a suitable number.
        fr.fetchBatchSize = 20
        
        if(text != ""){
            let t = text.lowercased()
            
            let tagPredicate = NSPredicate(format: "tag.name contains [cd] %@",t)
            let bookPredicate = NSPredicate(format: "book.title contains [cd] %@",t)
            let authorPredicate = NSPredicate(format: "book.authors.name contains [cd] %@",t)
                
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [tagPredicate,bookPredicate,authorPredicate])
            fr.predicate = predicate
            
        }
        
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.proxyForSorting", ascending: true),
                              NSSortDescriptor(key: "book.title", ascending: true)]
        
        return fr
        
    }
    
}
