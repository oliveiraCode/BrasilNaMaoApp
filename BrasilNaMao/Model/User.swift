//
//  User.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class User  {
    var id:String!
    var firstName:String!
    var lastName:String?
    var email:String!
    var password:String!
    var phone:String?
    var whatsapp:String?
    var image:UIImage!
    var creationDate:String?
    var businessesIds:[String]?
    var favoritesIds:[String]?
    
    
    init(id:String,firstName:String, lastName:String, email:String, password:String, phone:String, whatsapp:String, creationDate:String, businessesIds:[String], favoritesIds: [String]) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.phone = phone
        self.whatsapp = whatsapp
        self.creationDate = creationDate
        self.businessesIds = businessesIds
        self.favoritesIds = favoritesIds
        
    }
    
    init() {}
    
    func resetValuesOfUserAccount() {
        self.id = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.password = nil
        self.phone = nil
        self.whatsapp = nil
        self.image = nil
        self.creationDate = nil
    }
    
    convenience init(data: [String: Any],password:String) {
        
        
        let creationDate = data["creationDate"] as! String
        let id = data["id"] as! String
        let email = data["email"] as! String
        let firstName = data["firstName"] as! String
        let lastName = data["lastName"] as? String ?? ""
        let phone = data["phone"] as? String ?? "Indisponível"
        let whatsapp = data["whatsapp"] as? String ?? "Indisponível"
        let businessesIds = data["businessesIds"] as? [String] ?? [""]
        let favoritesIds = data["favoritesIds"] as? [String] ?? [""]
        
        
        self.init(id: id, firstName: firstName, lastName: lastName, email: email, password: password, phone: phone, whatsapp: whatsapp, creationDate: creationDate, businessesIds: businessesIds, favoritesIds: favoritesIds)
    }
    
    
}
