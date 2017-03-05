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
    
    var book: Book? = nil
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = book?.title
        reloadView()
        
        imageView.image = UIImage(named: "Dummy")
        
        if let b = book {
            if let thumbnail = b.thumbnail {
                loadThumbnail(thumbnail: thumbnail.binary as! Data)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).thumbnail(book: b, completion: { (data: Data) in
                    let thumbnail = Thumbnail.get(book: b, binary: data as NSData, context: self.context!)
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
        if let book = book{
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
        
        self.book = Book.setIsFavourite(book: book!, context: self.context!)
        reloadAndNotify()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.book = self.book
                vc.context = self.context
                
                Book.setLastOpened(book: book!, context: self.context!)
                
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
