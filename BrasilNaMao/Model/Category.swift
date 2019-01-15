//
//  Category.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

struct Category: Codable {
    var id: String? = nil
    var name:String
    
    init(name:String) {
        self.name = name
    }

}
