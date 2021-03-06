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
    
    //Convenience init from name
    convenience init(name: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Tag.entity().name!, in: context)!
        
        let tagName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.init(entity: entity, insertInto: context)
        self.name = tagName
        
        //By default Proxy for sorting is own tag name. Adding _ for being in first place
        switch tagName
        {
        case CONSTANTS.FavouritesName:
            self.proxyForSorting = "____" + tagName
        case CONSTANTS.FinishedBooks:
            self.proxyForSorting = "___" + tagName
        case CONSTANTS.Recent:
            self.proxyForSorting = "__" + tagName
        default:
            self.proxyForSorting = tagName
        }
        
        saveContext(context: context)
    }
    
    //Gets a Tag from DB. If not exists it creates one
    class func get(name: String, context: NSManagedObjectContext?) -> Tag{
        
        let fr = NSFetchRequest<Tag>(entityName: Tag.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Tag.init(name: name, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Tag.init(name: name, context: context!)
            }
        } catch{
            return Tag.init(name: name, context: context!)
        }
        
    }
    
}
