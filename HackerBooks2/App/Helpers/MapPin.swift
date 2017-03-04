//
//  UserLocation.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 03/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
