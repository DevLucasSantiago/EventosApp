//
//  MapPin.swift
//  EventosApp
//
//  Created by Lucas Santiago on 25/04/21.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    static func setPinUsingMKPointAnnotation(mapPin: MapPin) -> (MKPointAnnotation, MKCoordinateRegion){
       let annotation = MKPointAnnotation()
        annotation.coordinate = mapPin.coordinate
        annotation.title = mapPin.title
        annotation.subtitle = mapPin.locationName
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        return (annotation, coordinateRegion)
    }
}
