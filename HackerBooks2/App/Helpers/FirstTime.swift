//
//  FirstTime.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 26/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation

//Is first time launched?
public func isFirstTime() -> Bool {
    let userDef = UserDefaults.standard
    let firstTime = !userDef.bool(forKey: "isFirstTime")
    
    return firstTime
}

//Set is not first time
public func setAppLaunched() {
    let userDef = UserDefaults.standard
    userDef.set(true, forKey: "isFirstTime")
}
