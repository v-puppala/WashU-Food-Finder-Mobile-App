//
//  LocationPoint.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import Foundation
import MapKit
class LocationPoint: NSObject, MKAnnotation
{
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let date:Date
    let subtitle: String?
    let opt:String
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D,date:Date,subtitle: String,opt:String) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.date = date
        self.subtitle = subtitle
        self.opt = opt
    }
}
