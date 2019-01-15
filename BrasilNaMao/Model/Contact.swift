//
//  Contact.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import Foundation

class Contact:Codable {
    var email:String?
    var phone:String?
    var web:String?
    
    init(email:String, phone:String, web:String) {
        self.email = email
        self.phone = phone
        self.web = web
    }
}
