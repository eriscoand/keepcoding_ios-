//
//  PDFViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    var booktag: BookTag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = booktag?.book?.title
        
        guard let urlPDF = booktag!.book?.pdf else { return }
        
        activityIndicator.startAnimating()
        
        DataInteractor(manager: DownloadAsyncGCD()).execute(urlString: urlPDF) { (data: Data) in
            do{
                let url = try getInternalUrl(file: urlPDF)
                self.webView.load(data, mimeType: "application/pdf", textEncodingName: "", baseURL: url.deletingLastPathComponent())
                self.activityIndicator.stopAnimating()
            }catch{
                fatalError("Error: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
