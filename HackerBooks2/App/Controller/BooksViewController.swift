//
//  ViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 23/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

class BooksViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fetchedResultsController: NSFetchedResultsController<BookTag>? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = context else { return }
        
        fetchedResultsController?.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
        }
    }


}

