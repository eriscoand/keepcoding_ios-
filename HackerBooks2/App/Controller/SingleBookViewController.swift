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
        
        if var book = booktag?.book{
            if let thumbnail = booktag?.book?.thumbnail {
                loadThumbnail(thumbnail: thumbnail.binary as! Data)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).thumbnail(book: book, completion: { (data: Data) in
                    book = Book.bookFromTitle(title: book.title!, context: self.context)
                    let thumbnail = Thumbnail(context: self.context!)
                    thumbnail.book = book
                    thumbnail.binary = data as NSData?
                    saveContext(context: self.context!)
                    self.loadThumbnail(thumbnail: thumbnail.binary as! Data)
                })
            }
        }
        
    }
    
    func loadThumbnail(thumbnail: Data){
        self.imageView.image = UIImage(data: thumbnail)
    }
    
    func reloadView(){
        if(booktag?.book?.isFavourite)!{
            favButton.title = CONSTANTS.FavouritesName
        }else{
            favButton.title = "!" + CONSTANTS.FavouritesName
        }
    }
    
    func reloadAndNotify(){
        reloadView()
        notifyFavouritesDidChanged()
        saveContext(context: context!)
    }

    @IBAction func favButtonClicket(_ sender: Any) {
        
        let book = Book.bookFromTitle(title: (self.booktag?.book?.title)!, context: context)
        let tag = Tag.tagFromName(name: CONSTANTS.FavouritesName, context: context)
        
        let booktag = BookTag.booktagFromBookTag(book: book, tag: tag, context: context)
        
        book.isFavourite = !book.isFavourite
        
        if(!book.isFavourite){
            context?.delete(booktag)
        }
        
        reloadAndNotify()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.booktag = booktag
                vc.context = self.context
                
                let book = Book.bookFromTitle(title: (self.booktag?.book?.title)!, context: context)
                let tag = Tag.tagFromName(name: CONSTANTS.LastReading, context: context)
                
                for bt in tag.booktag!{
                    context?.delete(bt as! NSManagedObject)
                }
                
                let _ = BookTag.booktagFromBookTag(book: book, tag: tag, context: context)
                
                reloadAndNotify()
                
            }
        }
    }
    
    func notifyFavouritesDidChanged(){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: CONSTANTS.CollectionViewChanged),
                                   object: nil)
        nc.post(notif as Notification)
    }

}
