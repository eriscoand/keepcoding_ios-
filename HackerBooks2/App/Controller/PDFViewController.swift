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
    
    var context: NSManagedObjectContext? = nil
    
    var booktag: BookTag?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = booktag?.book?.title
        
        activityIndicator.startAnimating()
        
        if var book = booktag?.book{
            if let pdf = booktag?.book?.pdf {
                loadPdf(pdf: pdf.binary as! Data, urlString: book.pdfUrl!)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).pdf(book: book, completion: { (data: Data) in
                    book = Book.bookFromTitle(title: book.title!, context: self.context)
                    let pdf = Pdf(context: self.context!)
                    pdf.book = book
                    pdf.binary = data as NSData?
                    saveContext(context: self.context!)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
