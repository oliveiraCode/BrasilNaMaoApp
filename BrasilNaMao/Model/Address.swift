//
//  Address.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import Foundation

class Address {
    var street:String?
    var city:String?
    var province:String?
    var postalCode:String?
    var latitude:Double?
    var longitude:Double?
    
    func addressGeoCode () -> String{
        return "\(self.street!), \(self.city!), \(self.province!) \(self.postalCode!)"
    }

    
}
