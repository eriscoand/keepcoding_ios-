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
