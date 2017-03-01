//
//  JSONProcessing.swift
//  HackerBook
//
//  Created by Eric Risco de la Torre on 31/01/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Functions

func jsonLoadFromData(dataInput data: Data) throws -> JSONArray{
    
    if let maybeArray = try? JSONSerialization.jsonObject(with: data,
                                                          options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray {
        return array
    }else{
        throw HackerBookError.wrongJsonFormat
    }
    
}

func decodeBooks(books json: JSONArray, context: NSManagedObjectContext) throws{
    
    let _ = try json.flatMap({try decodeBook(book: $0, context: context)})
    
}

func decodeBook(book json: JSONDictonary, context: NSManagedObjectContext) throws{
    
    let book = Book(context: context)
    
    var image = CONSTANTS.DefaultImage
    if let urlImageString = json["image_url"] as? String {
        image = urlImageString
    }
    
    var pdf = CONSTANTS.DefaultPdf
    if let urlPDFString = json["pdf_url"] as? String{
        pdf = urlPDFString
    }
    
    guard let title = json["title"] as? String else{
        throw HackerBookError.wrongJsonFormat
    }
    
    var authors = NSSet()
    if let authorsString = json["authors"] as? String{
        authors = Author.fromStringToSet(s: authorsString, context: context) as NSSet
    }
    
    book.title = title
    book.addToAuthors(authors)
    book.thumbnailUrl = image
    book.pdfUrl = pdf
    saveContext(context: context)
    
    if let tagsString = json["tags"] as? String{
        let tags = Tag.fromStringToSet(s: tagsString, context: context)
        for each in tags{
            let _ = BookTag.booktagFromBookTag(book: book, tag: each, context: context)
        }
    }    
    
}
