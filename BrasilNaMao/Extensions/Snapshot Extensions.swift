//
//  Snapshot Extensions.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot{
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        
        var documentJson = data()
        if includingId {
            documentJson!["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson!, options:[])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
}
