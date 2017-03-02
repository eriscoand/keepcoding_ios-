//
//  AddEditAnnotationViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddEditAnnotationViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var annotationImage: UIImageView!
    
    var annotation: Annotation!
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = annotation.photo,
            let binary = photo.binary {
            self.annotationImage.image = UIImage(data: binary as Data)
        }else{
            self.annotationImage.image = UIImage(named: "camera")
        }
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let context = annotation.managedObjectContext else { return }
        
        annotation = Annotation.get(id: annotation.objectID, book: book, title: titleText.text!, text: descriptionText.text, page: 0, context: context)
        saveContext(context: context)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
    }
    
    @IBAction func shareClicked(_ sender: Any) {
    }
}
