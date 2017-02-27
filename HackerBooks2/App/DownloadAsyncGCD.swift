//
//  DownloadAsyncGCD.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class DownloadAsyncGCD: DownloadAsync {
    
    public func downloadJson(urlString: String, context: NSManagedObjectContext, completion: @escaping (Void) -> Void, onError:  ErrorClosure?){
        
        DispatchQueue.global().async {
            do{
                let json_data = try getFileFrom(urlString: urlString)
                let json = try jsonLoadFromData(dataInput: json_data)
                try decodeBooks(books: json, context: context)
                saveContext(context: context)
                
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                if let errorClosure = onError {
                    errorClosure(error)
                }
            }
        }
        
    }
    
    public func downloadData(urlString: String, completion: @escaping (Data) -> Void, onError:  ErrorClosure?){
        
        DispatchQueue.global().async {
            
            if let url = URL(string: urlString){
                do{
                    let data = try Data(contentsOf: url)
                    
                    DispatchQueue.main.async {
                        completion(data)
                    }
                    
                } catch {
                    if let errorClosure = onError {
                        errorClosure(error)
                    }
                    
                }
            }
        }
    
    }
    
}
