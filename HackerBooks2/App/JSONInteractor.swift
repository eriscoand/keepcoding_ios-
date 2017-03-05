//
//  JSONInteractor.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class JSONInteractor: Interactor {
    
    public func execute(urlString: String, context: NSManagedObjectContext, completion: @escaping (Void) -> Void) {
        
        manager.downloadJson(urlString: urlString, context: context, completion: { (Void) in
            completion()
        }, onError: nil)        
        
    }
    
}
