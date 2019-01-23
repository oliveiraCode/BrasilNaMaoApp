//
//  CLLocationService.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-23.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import CoreLocation

class CLLocationService {
    
    static let shared = CLLocationService()
    
    func getCoordinateFromGeoCoder(address:String, completionHandler: @escaping (CLLocation?, Error?) -> Void) {
        var locationCoordinate = CLLocation()
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                locationCoordinate = (placemarks?.first?.location)!
                completionHandler(locationCoordinate, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
}
