//
//  BookCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
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
            
            DataInteractor(manager: DownloadAsyncGCD()).execute(urlString: (newValue.book?.thumbnail)!) { (data: Data) in
                self.bookImage.image = UIImage(data: data)
            }
            
        }
    }
    
}
