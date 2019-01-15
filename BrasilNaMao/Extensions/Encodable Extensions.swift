//
//  Encodable Extensions.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String:Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String:Any] else {throw MyError.encodingError}
        
        for key in keys {
            json[key] = nil
        }
        return json
    }
    
    func toJson() throws -> [String:Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String:Any] else {throw MyError.encodingError}
     
        return json
    }
}
