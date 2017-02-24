//
//  FoundationExtensions.swift
//  HackerBook
//
//  Created by Eric Risco de la Torre on 31/01/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation

extension Bundle{
    
    func url(forResource name: String) -> URL?{
        
        let tokens = name.components(separatedBy: ".")
        return url(forResource: tokens[0], withExtension: tokens[1])
        
    }
    
}
