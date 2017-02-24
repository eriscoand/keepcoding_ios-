//
//  JSONProcessing.swift
//  HackerBook
//
//  Created by Eric Risco de la Torre on 31/01/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit

typealias JSONObject = AnyObject;
typealias JSONDictonary = [String: JSONObject];
typealias JSONArray = [JSONDictonary];


//MARK: - Functions
func decodeBook(book json: JSONDictonary) throws -> Book {
    
    var image = Data()
    
    //Try to load the image from the json's url, if not it loads the bacon image
    if let urlImageString = json["image_url"] as? String {
        image = try getFileFrom(stringUrl: urlImageString)
    }else{
        let urlImageString = CONSTANTS.DefaultImage
        if let defaultImageURL = Bundle.main.url(forResource: urlImageString){
            image = try! Data(contentsOf: defaultImageURL)
        }
    }
    
    //We initially load the bacon ipsum pdf
    let defaultPDFURLString = CONSTANTS.DefaultPdf
    guard let defaultPDFURL = Bundle.main.url(forResource: defaultPDFURLString),
        let pdf = try? Data(contentsOf: defaultPDFURL) else{
            throw HackerBookError.resourcePointedByUrlNotReachable
    }
    
    //we will need the pdf url for the webview
    guard let urlPDF = json["pdf_url"] as? String else{
        throw HackerBookError.wrongJsonFormat
    }
    
    guard let title = json["title"] as? String else{
        throw HackerBookError.wrongJsonFormat
    }
    
    var authors = Set<Author>()
    if let authorsString = json["authors"] as? String{
        //authors = Author.fromStringToSet(s: authorsString)
    }
    
    var tags = Set<Tag>()
    if let tagsString = json["tags"] as? String{
        //tags = Tag.fromStringToSet(s: tagsString)
    }
    
    /*return Book(title: title,
                authors: authors,
                tags: tags,
                thumbnail: image,
                pdf: pdf,
                urlPDF : urlPDF)*/
    
}

func decodeBooks(books json: JSONArray) throws -> Set<Book>{
    
    let bookArray = try json.flatMap({try decodeBook(book: $0)})
    
    return Book.from(array: bookArray)
    
}

func decodeTags(forBooks books: Set<Book>) throws -> Set<Tag>{
    
    var tags = Set<Tag>()
    
    for book in books{
        for tag in book.tags{
            tags.insert(tag)
        }
    }
    
    return tags
    
}

func jsonLoadFromData(dataInput data: Data) throws -> JSONArray{
    
    if let maybeArray = try? JSONSerialization.jsonObject(with: data,
                                                          options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray {
        return array
    }else{
        throw HackerBookError.wrongJsonFormat
    }
    
}


