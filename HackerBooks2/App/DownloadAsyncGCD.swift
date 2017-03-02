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
                                
                saveContext(context: context, process: true)
                
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
            //let data = try getFileFrom(urlString: urlString) //--OLD getting data and saving it to Library
                
            var data = Data()
            if let url = URL.init(string: urlString){
                do{
                    data = try Data.init(contentsOf: url)
                }catch{
                    data = Data()
                }
            }
                
            DispatchQueue.main.async {
                completion(data)
            }
            
        }
    
    }
    
}
