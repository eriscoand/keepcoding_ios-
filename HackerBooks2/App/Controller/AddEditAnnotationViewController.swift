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
    var page: Int? = 0
    
    var locationEnabled = false
    var timer: Timer?    
    let locManager = CLLocationManager()
    var loc: CLLocation?
    var coor: CLLocationCoordinate2D?
    var locationError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let p = page {
            pageNumber.text = p.description
        }
        
        if let editAnnotation = annotation {
            titleText.text = editAnnotation.title
            descriptionText.text = editAnnotation.text
            dateCreation.text = formatDate(editAnnotation.creationDate as! Date)
            dateModify.text = formatDate(editAnnotation.modifiedDate as! Date)
            
            if let image = editAnnotation.photo?.binary {
                annotationImage.image = UIImage(data:image as Data,scale:1.0)
            }
            
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
        if let number = Int32(pageNumber.text!){
            annotation?.page = number
        }
        
        if(locationEnabled){
            if let coor = loc?.coordinate{
                let l = Location.init(annotation: annotation!, lat: coor.latitude, lng: coor.longitude, address: directionText.text, context: context)
                l.lat = coor.latitude
                l.long = coor.longitude
                l.address = directionText.text
            }
        }
        
        if let img = annotationImage.image {
            let data = UIImagePNGRepresentation(img) as NSData?
            let _ = Photo.init(annotation: annotation!, binary: data, context: context)
        }
        
        saveContext(context: context, process: true)
        
        notifyListDidChanged()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func notifyListDidChanged(){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: CONSTANTS.AnnotationsViewChanged),
                                   object: nil)
        nc.post(notif as Notification)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            loadCamera()
        }
    }
    
    @IBAction func galleryClicked(_ sender: Any) {
        loadLibrary()
    }
    
    
    @IBAction func shareClicked(_ sender: Any) {
        loadFacebookShare()
    }
        
}
