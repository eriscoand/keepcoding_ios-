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
    
    // MARK: - Init
    
    convenience init (title: String, thumbnailUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Book.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.pdfUrl = pdfUrl
        
        saveContext(context: context)
        
    }
    
    // MARK: - Get or create
    
    //Gets a Book from DB. If not exists it creates one
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
    
    // MARK: - View Utils
    
    //Used in the view. From the list to a string
    var authorsString : String{
        get{
            var ret = ""
            for author in authors!{
                ret += (author as AnyObject).name + " - "
            }
            return ret
        }
    }
    
    //Transform array to set
    class func from(array arr: [Book]) -> Set<Book>{
        var ret = Set<Book>()
        
        for book in arr{
            ret.insert(book)
        }
        
        return ret
    }
    
    // MARK: - Favourite Handler
    
    //Set a book as favourite and creating or deleting the favourite tag for the book
    class func setIsFavourite(book: Book, context: NSManagedObjectContext) -> Book{
        
        let tag = Tag.get(name: CONSTANTS.FavouritesName, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        book.isFavourite = !book.isFavourite
        
        if(!book.isFavourite){
            context.delete(booktag)
        }
        
        return book
        
    }
    
    // MARK: - Last Opened Handler
    
    //Archive Book before saving it to UserDefaults or iCloud
    class func archiveUriFrom(book: Book) -> Data? {
        let uri = book.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri)
    }
    
    //Unarchive Book from UserDefaults or iCloud
    class func bookFrom(archivedURI: Data, context: NSManagedObjectContext) -> Book? {
        if let uri: URL = NSKeyedUnarchiver.unarchiveObject(with: archivedURI) as? URL, let nid = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            let book = context.object(with: nid) as! Book
            return book
        }
        return nil
    }
    
    //Get last opened. First we try iCloud, if not we get from UserDefaults
    class func getLastOpened(context: NSManagedObjectContext) -> Book?{
        
        var returnBook: Book? = nil
        
        if let lastOpened = NSUbiquitousKeyValueStore.loadBookLastOpen(context: context){  //TRY to get Last book from iCloud
            returnBook = lastOpened
        }else if let lastOpened = UserDefaults.loadBookLastOpen(context: context) {  //TRY to get Last book from UserDefaults
            returnBook = lastOpened
        }
        
        if let book = returnBook{
            return Book.get(title: book.title!, context: context)
        }
        
        return nil
        
    }
    
    //Set Last Opened to UserDefaults and iCloud
    class func setLastOpened(book: Book, context: NSManagedObjectContext){
        
        UserDefaults.saveBookLastOpen(book: book)  //SAVE to UserDefaults
        NSUbiquitousKeyValueStore.saveBookLastOpen(book: book) //SAVE to iCloud
        
    }
    
    // MARK: - Recently Opened Handler
    
    class func recentlyOpened(book: Book, context: NSManagedObjectContext){
     
        let tag = Tag.get(name: CONSTANTS.Recent, context: context)
        let _ = BookTag.get(book: book, tag: tag, context: context)
        
        book.openedDate = NSDate()
        
    }
    
    // MARK: - Finished Handler
    
    class func finished(book: Book, context: NSManagedObjectContext){
        
        book.finishedReading = true
        let tag = Tag.get(name: CONSTANTS.FinishedBooks, context: context)
        let _ = BookTag.get(book: book, tag: tag, context: context)
        
    }
    
}
