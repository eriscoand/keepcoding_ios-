//
//  PDFViewController+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 05/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension PDFViewController: UIScrollViewDelegate,UIWebViewDelegate {
    
    func getCurrentPage() -> Int {
        guard let numberOfPages = self.book?.pdf?.numberOfPages else{
            return 0
        }
        
        let padding: CGFloat = 10
        let pages: CGFloat = CGFloat(numberOfPages + 1)
        
        let totalHeight = self.webView.scrollView.contentSize.height
        let totalPadding = padding * pages
        let page = (totalHeight - totalPadding)/CGFloat(numberOfPages)
        
        let offset = self.webView.scrollView.contentOffset.y
        
        let actualPage = Int(round(offset/(padding+page))) + 1
        return actualPage
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reload()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reload()
    }
    
    func reload(){
        let page = getCurrentPage()
        
        let fetchedResultsController = Annotation.fetchController(book: book!, pageNumber: page, context: self.context!)
        if  let numberOfNotes = fetchedResultsController.fetchedObjects?.count {
            notesbutton.title = "\(numberOfNotes) Notes"
        }else{
            notesbutton.title = "Notes"
        }
        
        if page != self.actualPage {
            self.actualPage = page
            
            if let pdf = self.book?.pdf{
                numberPagesButton.title = "Page \(page.description) of \(pdf.numberOfPages)"
            }else{
                numberPagesButton.title = ""
            }
            
            if let b = book{
                
                if Int32(page) > b.actualPage {
                    book?.actualPage = Int32(page)
                }
                
                if Int32(page) == b.pdf?.numberOfPages{
                    Book.finished(book: book!, context: context!)
                    
                    let nc = NotificationCenter.default
                    let notif = NSNotification(name: NSNotification.Name(rawValue: CONSTANTS.CollectionViewChanged),
                                               object: nil)
                    nc.post(notif as Notification)
                }
                
                saveContext(context: self.context!, process: true)
            }
            
            
        }
        
        
        
        
    }
    
}
