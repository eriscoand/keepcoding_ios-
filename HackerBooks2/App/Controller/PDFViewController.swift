//
//  PDFViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData

class PDFViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var notesbutton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    var context: NSManagedObjectContext? = nil    
    var booktag: BookTag?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = booktag?.book?.title
        
        activityIndicator.startAnimating()
        
        disableButtons()
        
        if var book = booktag?.book{
            if let pdf = booktag?.book?.pdf {
                loadPdf(pdf: pdf.binary as! Data, urlString: book.pdfUrl!)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).pdf(book: book, completion: { (data: Data) in
                    book = Book.get(title: book.title!, context: self.context!)
                    let pdf = Pdf.get(book: book, binary: data as NSData, context: self.context!)
                    self.loadPdf(pdf: pdf.binary as! Data, urlString: book.pdfUrl!)
                })
            }
        }
    }
    
    func loadPdf(pdf: Data, urlString: String){
        if let url = URL.init(string: urlString){
            self.webView.load(pdf, mimeType: "application/pdf", textEncodingName: "", baseURL: url.deletingLastPathComponent())
            self.activityIndicator.stopAnimating()
        }
        enableButtons()
    }
    
    func enableButtons(){
        addButton.isEnabled = true
        notesbutton.isEnabled = true
        mapButton.isEnabled = true
    }
    
    func disableButtons(){
        addButton.isEnabled = false
        notesbutton.isEnabled = false
        mapButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier
            {
            case "ShowNotes":
                let vc = segue.destination as! AnnotationsViewController
                vc.context = self.context
                if let bt = self.booktag{
                    vc.book = bt.book!
                    vc.fetchedResultsController = Annotation.fetchController(book: bt.book!, context: self.context!)
                }
                break
            case "AddNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                if let bt = self.booktag{
                    vc.book = bt.book!
                }
                break
            case "ShowMap":
                let vc = segue.destination as! MapViewController
                if let bt = self.booktag{
                    vc.book = bt.book!
                    vc.fetchedResultsController = Annotation.fetchController(book: bt.book!, context: self.context!)
                }
                break
            default:
                break
            }
        }
    }

}
