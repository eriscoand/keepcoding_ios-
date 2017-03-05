//
//  Date.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 05/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation

extension Date{
    
    static func difference(day1: Date, day2: Date) -> Int{
        let c = (Calendar.current as NSCalendar).components([.day], from: day1, to: day2, options: [])
        return c.day!
    }
    
}
