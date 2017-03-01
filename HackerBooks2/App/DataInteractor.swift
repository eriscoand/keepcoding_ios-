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
    
    public func pdf(book: Book, completion: @escaping (Data) -> Void) {
        
        manager.downloadData(urlString: book.pdfUrl!, completion: { (data: Data) in
            assert(Thread.current == Thread.main)
            completion(data)
        }, onError: nil)
        
    }
    
    public func thumbnail(book: Book, completion: @escaping (Data) -> Void) {
        
        manager.downloadData(urlString: book.thumbnailUrl!, completion: { (data: Data) in
            assert(Thread.current == Thread.main)
            completion(data)
        }, onError: nil)
        
    }
    
}
