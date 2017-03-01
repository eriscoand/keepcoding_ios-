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
    
    class func tagFromName(name: String, context: NSManagedObjectContext?, order: String = "999") -> Tag{
        
        let tagName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fr = NSFetchRequest<Tag>(entityName: Tag.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == %@", tagName)
        
        do{
            let rows = try context?.fetch(fr)
            if let r = rows{
                if r.count > 0{
                    return r.first!
                }
            }
        }catch{
            //TODO
        }
        
        let tag = Tag(context: context!)
        tag.name = tagName
        tag.order = order
        
        saveContext(context: context!)
        
        return tag        
        
    }
    
    class func fromStringToSet(s : String, context: NSManagedObjectContext) -> Set<Tag>{
        var ret = Set<Tag>()
        let arr = s.characters.split{$0 == ","}.map(String.init)
        for each in arr{
            ret.insert(tagFromName(name: each, context: context))
        }
        return ret
    }
    
}
