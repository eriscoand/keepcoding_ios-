//
//  NSUserDefaults.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UserDefaults {
    
    class func saveBookTagLastOpen(booktag: BookTag) {
        if let data = BookTag.archiveUriFrom(booktag: booktag) {
            UserDefaults.standard.set(data, forKey: CONSTANTS.LastBookOpen)
        }
    }
    
    class func loadBookLastOpen(context: NSManagedObjectContext) -> BookTag? {
        if let uriDefault = UserDefaults.standard.object(forKey: CONSTANTS.LastBookOpen) as? Data {
            return BookTag.bookTagFrom(archivedURI: uriDefault, context: context)
        }
        
        return nil
    }
    
}

