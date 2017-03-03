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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        fetchedResultsController?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier
            {
            case "AddNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                vc.book = book!
                break
            case "EditNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                vc.book = book!
                
                let selectedIndex = collectionView.indexPathsForSelectedItems?.last
                let annotation = fetchedResultsController?.object(at: selectedIndex!)
                
                vc.annotation = annotation
                
                break
            default:
                break
            }
        }
    }
    
}
