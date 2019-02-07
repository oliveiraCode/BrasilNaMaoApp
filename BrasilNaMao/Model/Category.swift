//
//  Category.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation


struct Category{
    var id: String? = nil
    var name:String
    
    var dictionary: [String: Any] {
        return [
            "id": id!,
            "name": name
        ]
    }
}

extension Category{
    init?(dictionary: [String : Any], id: String) {
        guard   let name = dictionary["name"] as? String
            else { return nil }
        
        self.init(id: id,name: name)
    }
}
