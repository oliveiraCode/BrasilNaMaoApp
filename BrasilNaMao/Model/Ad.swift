//
//  Ad.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class Ad:Codable {
    var id:String?
    var imageStorage:String?
    var description:String?
    var name:String?
    var address:Address
    var contact:Contact
    var creationDate:String?
    var category:String?
    var user_id:String?
    
    init(imageStorage:String, description:String, name:String,address:Address, contact:Contact, creationDate:String, category:String, user_id:String) {
        self.imageStorage = imageStorage
        self.description = description
        self.name = name
        self.address = address
        self.contact = contact
        self.creationDate = creationDate
        self.category = category
        self.user_id = user_id
    }
}
