//
//  SingleBookViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit

class SingleBookViewController: UIViewController {
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var booktag: BookTag? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = booktag?.book?.title
        
        imageView.image = UIImage(named: "Dummy")
        DataInteractor(manager: DownloadAsyncGCD()).execute(urlString: (booktag?.book?.thumbnail)!) { (data: Data) in
            self.imageView.image = UIImage(data: data)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func favButtonClicket(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.booktag = booktag
            }
        }
    }

}
