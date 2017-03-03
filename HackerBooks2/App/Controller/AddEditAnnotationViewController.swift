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
import CoreLocation

class AddEditAnnotationViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var annotationImage: UIImageView!
    @IBOutlet weak var coordinates: UITextField!
    @IBOutlet weak var pageNumber: UITextField!
    @IBOutlet weak var directionText: UITextField!
    @IBOutlet weak var dateCreation: UILabel!
    @IBOutlet weak var dateModify: UILabel!
    
    var annotation: Annotation? = nil
    var book: Book!
    
    var locationEnabled = false
    var timer: Timer?
    
    let locManager = CLLocationManager()
    var loc: CLLocation?
    var coor: CLLocationCoordinate2D?
    var locationError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editAnnotation = annotation {
            titleText.text = editAnnotation.title
            descriptionText.text = editAnnotation.text
            dateCreation.text = formatDate(editAnnotation.creationDate as! Date)
            dateModify.text = formatDate(editAnnotation.modifiedDate as! Date)
            pageNumber.text = editAnnotation.page.description
        }else{
            self.annotationImage.image = UIImage(named: "camera")
            dateCreation.text = formatDate(Date())
            dateModify.text = formatDate(Date())
        }
        
        self.titleText.delegate = self
        self.descriptionText.delegate = self
        
        handleLocation()
        
    }
        
    @IBAction func saveClicked(_ sender: Any) {
        guard let context = book?.managedObjectContext else { return }
        
        annotation = Annotation.get(id: annotation?.objectID, book: book, context: context)
        annotation?.title = titleText.text!
        annotation?.text = descriptionText.text
        annotation?.modifiedDate = NSDate()
        
        annotation?.page = 0
        if let number = Int16(pageNumber.text!){
            annotation?.page = number
        }
        
        saveContext(context: context, process: true)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
    }
    
    @IBAction func shareClicked(_ sender: Any) {
    }
        
}
