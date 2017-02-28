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
    @IBOutlet weak var sectionHeader: UILabel!
    
    var fetchedResultsController: NSFetchedResultsController<BookTag>? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = context else { return }
        
        subscribeFavouritesChanged()
        
        fetchedResultsController?.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier
            {
            case "ShowSingleBook":
                let selectedIndex = collectionView.indexPathsForSelectedItems?.last
                let booktag = fetchedResultsController?.object(at: selectedIndex!)
                let vc = segue.destination as! SingleBookViewController
                vc.booktag = booktag
                vc.context = self.context
            default:
                break
            }
        }
    }
    
    func subscribeFavouritesChanged(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(favouritesDidChanged),
                       name: NSNotification.Name(rawValue:CONSTANTS.FavouritesChanged),
                       object: nil)
    }
    
    func favouritesDidChanged(notification: NSNotification){
        self.fetchedResultsController = createBooksFetch(context: self.context!)
        saveContext(context: context!)
        self.collectionView.reloadData()
    }


}

