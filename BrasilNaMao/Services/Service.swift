//
//  CLLocationService.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-23.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import SWRevealViewController
import Firebase

class Service {
    
    static let shared = Service()
    
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
    
    func getTodaysDate() -> String{
        let date = NSDate()
        let calendar = NSCalendar.current
        let days = calendar.component(.day, from: date as Date)
        let months = calendar.component(.month, from: date as Date)
        let year = calendar.component(.year, from: date as Date)
        
        var day:String!
        var month:String!
        
        if days < 10 {
            day = "0\(days)"
        } else {
            day = "\(days)"
        }
        
        if months < 10 {
            month = "0\(months)"
        }else{
            month = "\(months)"
        }
        
        return "\(day!)/\(month!)/\(year)"
    }
    
    func getPeriodOfDay() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        
        var returnString = ""
        if hour <= 11 && minute <= 59 {
            returnString = periodOfDay.goodMorging
        }
        
        if hour > 11 && hour < 18 && minute >= 00 {
            returnString =  periodOfDay.goodAfternoon
        }
        
        if hour >= 18 && hour <= 23 && minute <= 59 {
            returnString =  periodOfDay.goodEvening
        }
        
        return returnString
    }
    
    func calculateDistanceKm(lat: Double, long: Double) -> Double{
        let adLocation = CLLocation(latitude: lat, longitude: long)
        let distanceKm = LocationManagerService.shared.currentLocation.distance(from: adLocation)/1000
        return distanceKm
    }
    
    
    func checkPermissionPhotoLibrary(completionHandler: @escaping (PHAuthorizationStatus) -> Void) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            completionHandler(.authorized)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    completionHandler(.authorized)
                }
            })
            break
        case .denied, .restricted :
            completionHandler(.denied)
            break
        }
    }

}


