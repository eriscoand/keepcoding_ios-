//
//  MapViewController.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 27/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var fetchedResultsController: NSFetchedResultsController<BookTag>? = nil
    var locationManager : CLLocationManager?
    var location: CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        let location = CLLocation.init(latitude: 51.51, longitude: -0.11)
        self.mapView.setCenter(location.coordinate, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    

}
