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
    @IBOutlet weak var numberPagesButton: UIBarButtonItem!
    
    var context: NSManagedObjectContext? = nil    
    var book: Book?
    var actualPage: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = book?.title
        
        activityIndicator.startAnimating()
        
        self.webView.delegate = self
        self.webView.scrollView.delegate = self
        
        disableButtons()
        reload()
        
        if let b = book {
            if let pdf = b.pdf {
                loadPdf(pdf: pdf.binary as! Data, urlString: b.pdfUrl!)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).pdf(book: b, completion: { (data: Data, numberOfPages: Int) in
                    let pdf = Pdf.get(book: b, binary: data as NSData, numberOfPages: numberOfPages, context: self.context!)
                    
                    self.book?.pdf = pdf
                    
                    self.loadPdf(pdf: pdf.binary as! Data, urlString: b.pdfUrl!)
       
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
                vc.book = book!
                vc.page = self.actualPage
                vc.fetchedResultsController = Annotation.fetchController(book: book!, pageNumber: self.actualPage, context: self.context!)
                break
            case "AddNote":
                let vc = segue.destination as! AddEditAnnotationViewController
                vc.book = book!
                vc.page = self.actualPage
                break
            case "ShowMap":
                let vc = segue.destination as! MapViewController
                vc.book = book!
                vc.fetchedResultsController = Annotation.fetchController(book: book!, context: self.context!)
                break
            default:
                break
            }
        }
    }

}
