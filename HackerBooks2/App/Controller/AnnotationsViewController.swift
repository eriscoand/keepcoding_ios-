//
//  AnnotationsViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 01/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

class AnnotationsViewController: UIViewController{
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Annotation>? = nil
    var book: Book?
    var page: Int? = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        if let p = page {
            self.title = "Notes page \(p)"
        }
        
        fetchedResultsController?.delegate = self
        subscribeFavouritesChanged()
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
    }
    
    func subscribeFavouritesChanged(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(listDidChanged),
                       name: NSNotification.Name(rawValue:CONSTANTS.AnnotationsViewChanged),
                       object: nil)
    }
    
    func listDidChanged(notification: NSNotification){
        fetchedResultsController = Annotation.fetchController(book: book!, pageNumber: page!, context: context!)
        self.collectionView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier
            {
            case "AddNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                vc.book = book!
                vc.page = self.page
                break
            case "EditNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                vc.book = book!
                
                vc.page = self.page
                
                let selectedIndex = collectionView.indexPathsForSelectedItems?.last
                let annotation = fetchedResultsController?.object(at: selectedIndex!)
                
                vc.annotation = annotation
                
                break
            case "ShowMap":
                let vc = segue.destination as! MapViewController
                vc.book = book
                vc.fetchedResultsController = Annotation.fetchController(book: book!, context: self.context!)
                break
            default:
                break
            }
        }
    }
    
}
