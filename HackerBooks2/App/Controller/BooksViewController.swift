//
//  ViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 23/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class BooksViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<BookTag>? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = context else { return }
        
        subscribeFavouritesChanged()
        
        fetchedResultsController?.delegate = self
    
        searchBar.delegate = self
        
        if let lastOpened = BookTag.getLastOpened(context: self.context!){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingleBookViewController") as! SingleBookViewController
            vc.context = self.context
            vc.booktag = lastOpened
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
        nc.addObserver(self, selector: #selector(listDidChanged),
                       name: NSNotification.Name(rawValue:CONSTANTS.CollectionViewChanged),
                       object: nil)
    }
    
    func listDidChanged(notification: NSNotification){
        fetchedResultsController = BookTag.fetchController(context: context!, text: "")
        self.collectionView.reloadData()
    }
    

}

