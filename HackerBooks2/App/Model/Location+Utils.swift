//
//  Location.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 03/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension Location{
    
    //Convenience init from annotation, latitude, longitude and address
    convenience init(annotation: Annotation, lat: Double?, lng: Double?, address: String?, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Location.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.annotation = annotation
        self.lat = lat!
        self.long = lng!
        self.address = address
        
    }
    
    //Gets a Location from DB. If not exists it creates one
    class func get(annotation: Annotation, lat: Double? = 0, lng: Double? = 0, address: String? = "", context: NSManagedObjectContext?) -> Location{
        let fr = NSFetchRequest<Location>(entityName: Location.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "annotation == %@", annotation)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Location.init(annotation: annotation, lat: lat, lng: lng, address: address, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Location.init(annotation: annotation, lat: lat, lng: lng, address: address, context: context!)
            }
        } catch{
            return Location.init(annotation: annotation, lat: lat, lng: lng, address: address, context: context!)
        }
    }
    
}
