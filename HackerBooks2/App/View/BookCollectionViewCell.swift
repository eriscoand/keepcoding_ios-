//
//  BookCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    var context: NSManagedObjectContext? = nil
    
    var _booktag: BookTag? = nil
    var book: BookTag{
        get{
            return _booktag!
        }
        set{
            _booktag = newValue
            titleLabel.text = newValue.book?.title
            authorsLabel.text = newValue.book?.authorsString
            
            bookImage.image = UIImage(named: "Dummy")
                
            if var book = newValue.book{
                if let thumbnail = newValue.book?.thumbnail {
                    loadThumbnail(thumbnail: thumbnail.binary as! Data)
                }else{
                    DataInteractor(manager: DownloadAsyncGCD()).thumbnail(book: book, completion: { (data: Data) in
                        book = Book.get(title: book.title!, context: self.context!)
                        let thumbnail = Thumbnail.get(book: book, binary: data as NSData, context: self.context!)
                        self.loadThumbnail(thumbnail: thumbnail.binary as! Data)
                    })
                }
            }
            
        }
    }
    
    func loadThumbnail(thumbnail: Data){
        self.bookImage.image = UIImage(data: thumbnail)
    }
    
}
