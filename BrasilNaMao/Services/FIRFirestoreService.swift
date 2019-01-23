//
//  FIRFirestoreService.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-10.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import Firebase

class FIRFirestoreService {
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure(){
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func get (){
       
        
        let db = Firestore.firestore()
        
        let citiesRef = db.collection("ad")
        
        let query = citiesRef.whereField("category", isEqualTo: "Tradutores")
        
        
        
        db.collection("ad").whereField("category", isEqualTo: "Tradutores")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let cities = documents.map { $0["name"]! }
                print("Current cities in CA: \(cities)")
        }
        
        
    }
    
    func createCategory<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference){
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
        }catch {
            print(error)
        }
    }
    
    func readCategory<T: Decodable>(from collectionReference: FIRCollectionReference, returnig objectType: T.Type, completion: @escaping ([T]) -> Void){
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else {return}
            
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
            }catch {
                print(error)
            }
        }
    }
    
    func createAd<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference){
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
        }catch {
            print(error)
        }
    }
}
