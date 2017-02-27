//
//  Tag+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Tag {
    
    class func fromStringToSet(s : String, context: NSManagedObjectContext) -> Set<Tag>{
        var ret = Set<Tag>()
        let arr = s.characters.split{$0 == ","}.map(String.init)
        for each in arr{
            let tag = Tag(context: context)
            tag.name = each
            ret.insert(tag)
        }
        return ret
    }
    
}
