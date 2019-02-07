//
//  Address.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import Foundation

class Address:Codable {
    var street:String?
    var complement:String?
    var city:String?
    var province:String?
    var postalCode:String?
    var latitude:Double?
    var longitude:Double?
    
    init(street:String, complement:String, city:String, province:String, postalCode:String, latitude:Double, longitude:Double) {
        self.street = street
        self.complement = complement
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {}
    
    func addressGeoCode () -> String{
        return "\(self.street!), \(self.city!), \(self.province!) \(self.postalCode!)"
    }

    
}
