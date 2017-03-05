//
//  AnnotationCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import CoreData
import UIKit

//View Cell class for Annotations Collection View
class AnnotationCollectionViewCell: UICollectionViewCell {
    
    var context: NSManagedObjectContext? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var annotationImage: UIImageView!
    
    var _annotation: Annotation? = nil
    var annotation: Annotation{
        get{
            return _annotation!
        }
        set{
            _annotation = newValue
            titleLabel.text = newValue.title
            
            
            if let photo = newValue.photo,
               let binary = photo.binary {
                self.annotationImage.image = UIImage(data: binary as Data)
            }else{
                self.annotationImage.image = UIImage(named: "camera")
            }
            
        }
    }
    
}

