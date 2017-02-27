//
//  DataInteractor.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit

public class DataInteractor: Interactor {
    
    public func execute(urlString: String, completion: @escaping (Data) -> Void) {
        
        manager.downloadData(urlString: urlString, completion: { (data: Data) in
            assert(Thread.current == Thread.main)
            completion(data)
        }, onError: nil)
        
    }
    
}
