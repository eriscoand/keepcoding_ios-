//
//  AnnotationsViewController+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 01/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension AnnotationsViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController?.sections![section]
        return sectionInfo!.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotationCell", for: indexPath) as? BookCollectionViewCell
        
        //cell?.book = (self.fetchedResultsController?.object(at: indexPath))!
        //cell?.context = self.context
        
        return cell!
    }
    
    
}
