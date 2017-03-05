//
//  Errors.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 24/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation

enum HackerBookError : Error{
    case wrongUrlFormatForJSONResource
    case resourcePointedByUrlNotReachable
    case wrongJsonFormat
    case NotInLibrary
}

enum PDFError: Error{
    case invalidURL
    case notAPDF
}
