//
//  MapViewController+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 03/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import MapKit

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate{
    
    //Load all annotations with location to the map
    func populateLocationList(){
        locationList = [MapPin]()
        if let objects = fetchedResultsController?.fetchedObjects{
            for each in objects {
                let annotation : Annotation = each as Annotation
                
                if let lng = annotation.location?.long,
                    let lat = annotation.location?.lat{
                    let coordinate = CLLocationCoordinate2DMake(lat, lng)
                    let mappin: MapPin = MapPin.init(coordinate: coordinate, title: annotation.title!, subtitle: "")
                    locationList?.append(mappin)
                }
                
            }
        }
    }
    
    //Centering all locations in the region of the map 💪
    func showLocationsCenteringRegion(){
        
        if let locationList = locationList {
            if(locationList.count > 0){
                var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180) //Top left of the world
                var bottomRight = CLLocationCoordinate2D(latitude: 80, longitude: -180) //Bottom right of the world
                
                //For all the locations find the most at left and the most at right
                for location in locationList {
                    topLeft.latitude = max(topLeft.latitude, location.coordinate.latitude)
                    topLeft.longitude = min(topLeft.longitude, location.coordinate.longitude)
                    bottomRight.latitude = min(bottomRight.latitude, location.coordinate.latitude)
                    bottomRight.longitude = max(bottomRight.longitude, location.coordinate.longitude)
                }
                
                //Get center of most left and right
                let centerLat = topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2
                let centerLng = topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2
                
                let center = CLLocationCoordinate2D(latitude: centerLat,longitude: centerLng)
                
                //Padding
                let addToBorder = 1.3
                let deltaLat = abs(topLeft.latitude - bottomRight.latitude) * addToBorder
                let deltaLng = abs(topLeft.longitude - bottomRight.longitude) * addToBorder
                
                //creating span
                let span = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLng)
                
                //creating region
                let region = MKCoordinateRegion(center: center, span: span)
                
                //creating map
                mapView.addAnnotations(locationList)
                mapView.regionThatFits(region)
                mapView.setRegion(region, animated: true)
            }
            
        }
        
    }
    
    
}
