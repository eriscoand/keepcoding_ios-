//
//  SingleBookViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

class SingleBookViewController: UIViewController {
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var booktag: BookTag? = nil
    var context: NSManagedObjectContext? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = booktag?.book?.title
        reloadView()
        
        imageView.image = UIImage(named: "Dummy")
        DataInteractor(manager: DownloadAsyncGCD()).execute(urlString: (booktag?.book?.thumbnail)!) { (data: Data) in
            self.imageView.image = UIImage(data: data)
        }
        
    }
    
    func reloadView(){
        if(booktag?.book?.isFavourite)!{
            favButton.title = CONSTANTS.FavouritesName
        }else{
            favButton.title = "!" + CONSTANTS.FavouritesName
        }
    }

    @IBAction func favButtonClicket(_ sender: Any) {
        
        if let book = booktag?.book{
            book.isFavourite = !book.isFavourite
            if(book.isFavourite){
                let booktagfavourite = BookTag(context: context!)
                
                let tag = Tag(context: context!)
                tag.name = CONSTANTS.FavouritesName
                
                booktagfavourite.book = book
                booktagfavourite.tag = tag
                
            }else{
                context?.delete(booktag!)
            }
        }
        
        reloadView()
        notifyFavouritesDidChanged()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.booktag = booktag
            }
        }
    }
    
    func notifyFavouritesDidChanged(){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: CONSTANTS.FavouritesChanged),
                                   object: nil)
        nc.post(notif as Notification)
    }

}
