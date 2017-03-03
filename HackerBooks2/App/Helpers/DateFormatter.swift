//
//  DateFormatter.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 03/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation

func formatDate(_ date: Date) -> String {
    return dateFormatter.string(from: date)
}
    
fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
