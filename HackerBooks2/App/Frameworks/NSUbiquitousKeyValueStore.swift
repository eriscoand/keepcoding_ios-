//
//  NSUbiquitousKeyValueStore.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 04/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension NSUbiquitousKeyValueStore{
    
    class func loadBookLastOpen(context: NSManagedObjectContext) -> BookTag?{
        let defaultValueStore = NSUbiquitousKeyValueStore.default()
        if let uriDefault = defaultValueStore.object(forKey: CONSTANTS.LastBookOpen) as? Data {
            return BookTag.bookTagFrom(archivedURI: uriDefault, context: context)
        }
        return nil
    }
    
    class func saveBookTagLastOpen(booktag: BookTag) {
        let defaultValueStore = NSUbiquitousKeyValueStore.default()
        if let data = BookTag.archiveUriFrom(booktag: booktag) {
            defaultValueStore.set(data, forKey: CONSTANTS.LastBookOpen)
        }
    }
    
}
