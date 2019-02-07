//
//  User.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class User  {
    var id:String!
    var firstName:String!
    var lastName:String!
    var email:String!
    var password:String!
    var phone:String!
    var whatsapp:String!
    var image:UIImage!
    var creationDate:String?
    var businessesIds:[String]?
    var favoritesIds:[String]?
    
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
    
}
