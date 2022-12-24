//
//  LocationManager.swift
//  location search
//
//  Created by Admin on 24/12/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    
    public func findLocation(with query: String, completion: @escaping (([Location]) -> Void)) {
        //converting string into location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { placemark, error in
          //  print("error")
            guard let placemark = placemark, error == nil else {
                completion([])
                print("error")
                return
            }
            //converting places in location model
            let models:[Location] = placemark.compactMap ({ placemark in
                var name = ""
                if let locationName = placemark.name {
                    name += locationName
                }
                if let adminRegion = placemark.administrativeArea {
                    name += ", \(adminRegion)"
                }
                if let locality = placemark.locality {
                    name += ", \(locality)"
                }
                if let country = placemark.country {
                    name += ", \(country)"
                }
                
                print("place mark data \n \(placemark) \n\n")
                let result = Location(title: name, coordinate: placemark.location?.coordinate)
                
                return result
            })
           
        }
    }
}
