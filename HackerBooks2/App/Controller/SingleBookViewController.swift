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
    var context: NSManagedObjectContext?

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
                    book = Book.get(title: book.title!, context: self.context!)
                    let thumbnail = Thumbnail.get(book: book, binary: data as NSData, context: self.context!)
                    self.loadThumbnail(thumbnail: thumbnail.binary as! Data)
                })
            }
        }
        
    }
    
    func loadThumbnail(thumbnail: Data){
        self.imageView.image = UIImage(data: thumbnail)
    }
    
    func reloadView(){
        
        favButton.title = "!⭐️"
        if let bt = booktag,
            let book = bt.book{
            if(book.isFavourite){
                favButton.title = "⭐️"
            }else{
                favButton.title = "!⭐️"
            }
        }
        
    }
    
    func reloadAndNotify(){
        reloadView()
        notifyListDidChanged()
        saveContext(context: context!, process: true)
    }

    @IBAction func favButtonClicket(_ sender: Any) {
        
        self.booktag?.book = Book.setIsFavourite(booktag: self.booktag!, context: self.context!)
        reloadAndNotify()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.booktag = self.booktag
                vc.context = self.context
                
                BookTag.setLastOpened(booktag: self.booktag!, context: self.context!)
                
                reloadAndNotify()
            }
        }
    }
    
    func notifyListDidChanged(){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: CONSTANTS.CollectionViewChanged),
                                   object: nil)
        nc.post(notif as Notification)
    }

}
