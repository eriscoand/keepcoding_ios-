//
//  BookCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

//View Cell class for Book Collection View
class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var readedLabel: UILabel!
    @IBOutlet weak var favouriteLabel: UILabel!
    
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
            
            //If the pdf has been opened already one time
            if let pdf = book.book?.pdf{
                readedLabel.isHidden = false
                if let b = book.book{
                    if b.finishedReading {
                        readedLabel.backgroundColor = UIColor.green
                        readedLabel.text = "FINISHED!!"
                    }else{
                        readedLabel.backgroundColor = UIColor.white
                        readedLabel.text = "Readed \(b.actualPage.description) of \(pdf.numberOfPages)"
                    }
                }
            }else{
                readedLabel.isHidden = true
            }
            
            bookImage.image = UIImage(named: "Dummy")
            
            if var book = newValue.book{
                
                if book.isFavourite{
                    favouriteLabel.text = "⭐️"
                }else{
                    favouriteLabel.text = ""
                }
                
                if let thumbnail = newValue.book?.thumbnail {
                    loadThumbnail(thumbnail: thumbnail.binary as! Data)
                }else{
                    //Download Image if not done it yet
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
