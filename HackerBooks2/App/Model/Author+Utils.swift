//
//  Author+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Author {

    class func fromStringToSet(s : String, context: NSManagedObjectContext) -> Set<Author>{
        var ret = Set<Author>()
        let arr = s.characters.split{$0 == ","}.map(String.init)
        for each in arr{
            let author = Author(context: context);
            author.name = each
            ret.insert(author)
        }
        return ret
    }
    
}
