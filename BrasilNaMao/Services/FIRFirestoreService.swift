//
//  FIRFirestoreService.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-10.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import CoreData
import KRProgressHUD

class FIRFirestoreService {
    
    static let shared = FIRFirestoreService()
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK - saveBusinessToFirestore
    func saveBusinessToFirestore (business:Business, imageArray:[UIImage]){
        
        let businessRef = db.collection(FIRCollectionReference.business)
        business.id = businessRef.document().collection(businessRef.collectionID).document().documentID
        
        var contactData: [String: Any] {
            return [
                "email": business.contact!.email!,
                "phone": business.contact!.phone!,
                "whatsapp":business.contact!.whatsapp!,
                "web": business.contact!.web!
            ]
        }
        
        var addressData: [String: Any] {
            return [
                "city": business.address!.city!,
                "postalCode": business.address!.postalCode!,
                "province": business.address!.province!,
                "street": business.address!.street!,
                "complement": business.address!.complement!,
                "latitude":business.address!.latitude!,
                "longitude":business.address!.longitude!
            ]
        }
        
        
        var adData: [String: Any] {
            return [
                "id":business.id!,
                "description": business.description!,
                "name": business.name!,
                "creationDate": business.creationDate!,
                "category": business.category!,
                "user_id": business.user_id!,
                "rating": business.rating!,
                "address":addressData,
                "hours":business.hours!,
                "contact":contactData
            ]
        }
        
        
        businessRef.document(business.id!).setData(adData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved")
            }
        }
        
        saveImageToStorage(business: business, imageArray: imageArray)
    }
    
    //MARK - readImageFromStorage
    func readImageFromStorage(business:Business, indexImage:Int, completionHandler: @escaping (URL?, Error?) -> Void) {
        
        let imageRef = Storage.storage().reference().child("ImageBusiness").child(business.id!).child("image\(indexImage)")
        
        imageRef.downloadURL { (url, error) in
            
            if error == nil {
                completionHandler(url,nil)
            } else {
                completionHandler(nil,error)
            }
            
        }
        
    }
    
    //MARK - readAllBusiness
    func readAllBusiness(completionHandler: @escaping ([Business?], Error?) -> Void) {
        
        let businessRef = db.collection(FIRCollectionReference.business)
        var businesses = [Business]()
        
        
        businessRef.order(by: "creationDate", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler([nil],err)
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let addressObj = Address()
                    let address = document.data()["address"] as! [String:Any]
                    
                    addressObj.street = address["street"] as? String
                    addressObj.complement = address["complement"] as? String
                    addressObj.city = address["city"] as? String
                    addressObj.province = address["province"] as? String
                    addressObj.postalCode = address["postalCode"] as? String
                    addressObj.latitude = address["latitude"] as? Double
                    addressObj.longitude = address["longitude"] as? Double
                    
                    let contactObj = Contact()
                    let contact = document.data()["contact"] as! [String:Any]
                    
                    contactObj.email = contact["email"] as? String
                    contactObj.phone = contact["phone"] as? String
                    contactObj.whatsapp = contact["whatsapp"] as? String
                    contactObj.web = contact["web"] as? String
                    
                    let hours = document.data()["hours"] as? [DailyHours]
                    
                    let businessObj = Business()
                    businessObj.id = document.data()["id"] as? String
                    businessObj.description = document.data()["description"] as? String
                    businessObj.name = document.data()["name"] as? String
                    businessObj.category = document.data()["category"] as? String
                    businessObj.user_id = document.data()["user_id"] as? String
                    businessObj.creationDate = document.data()["creationDate"] as? String
                    businessObj.rating = document.data()["rating"] as? Double
                    businessObj.address = addressObj
                    businessObj.contact = contactObj
                    businessObj.hours = hours
                    
                    businesses.append(businessObj)
                    
                }
                completionHandler(businesses,nil)
            }
        }
        
    }
    
    
    
    //MARK - saveImageToStorage
    func saveImageToStorage(business:Business, imageArray:[UIImage]){
        
        for (index,image) in imageArray.enumerated() {
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
            
            let storageRef = Storage.storage().reference().child("ImageBusiness").child(business.id!).child("image\(index+1)")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.putData(imageData, metadata: metaData)
            print("Image Uploaded successfully")
            
        }
    }
    
    //MARK - createUser
    func createUser(completionHandler: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: appDelegate.userObj.email, password: appDelegate.userObj.password) { (userResult, error) in
            
            if error != nil{
                completionHandler(error)
            }
            
            if error == nil && userResult != nil {
                print("User created!")
                self.appDelegate.userObj.id = Auth.auth().currentUser?.uid //get id from current user
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = "\(self.appDelegate.userObj.firstName!) \(self.appDelegate.userObj.lastName!)"
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        print("User display name changed!")
                        self.saveImageToStorage()
                        self.saveProfileToFireStore()
                        CoreDataService.shared.saveCurrentUserToCoreData()
                        completionHandler(nil)
                    } else {
                        completionHandler(error)
                    }
                })
            }
        }
    }
    
    //MARK - saveImageToStorage
    func saveImageToStorage(){
        
        guard let imageData = appDelegate.userObj.image.jpegData(compressionQuality: 0.75) else {return}
        
        let storageRef = Storage.storage().reference().child("ImageUsers").child(appDelegate.userObj.id!)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData)
        print("Image Uploaded successfully")
        
    }
    
    //MARK - saveProfileToFireStore
    func saveProfileToFireStore() {
        
        let userRef = db.collection(FIRCollectionReference.users)
        
        var userData: [String: Any] {
            return [
                "id":appDelegate.userObj.id,
                "firstName": appDelegate.userObj.firstName,
                "lastName": appDelegate.userObj.lastName,
                "email": appDelegate.userObj.email,
                "phone": appDelegate.userObj.phone,
                "whatsapp": appDelegate.userObj.whatsapp,
                "businessesIds": appDelegate.userObj.businessesIds ?? "",
                "favoritesIds": appDelegate.userObj.favoritesIds ?? "",
                "creationDate": appDelegate.userObj.creationDate!,
            ]
        }
        
        
        userRef.document(appDelegate.userObj.id).setData(userData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved")
            }
        }
    }
    
    
    //MARK - createCategory
    func createCategory(category:Category){
        
        var categoryData: [String: Any] {
            return [
                "name": category.name
            ]
        }
        
        
        let categoryRef = db.collection(FIRCollectionReference.category)
        
        categoryRef.addDocument(data: categoryData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved")
            }
        }
        
    }
    
    //MARK - readCategory
    func readCategory(completionHandler: @escaping ([Category?], Error?) -> Void) {
        
        db.collection("category").addSnapshotListener { documentSnapshot, error in
            
            if error == nil {
                guard let snapshot = documentSnapshot else {
                    print("Error fetching documents results: \(error!)")
                    return
                }
                
                
                let results = snapshot.documents.map { (document) -> Category in
                    if let category = Category(dictionary: document.data(), id: document.documentID) {
                        return category
                    } else {
                        fatalError("Unable to initialize type \(Category.self) with dictionary \(document.data())")
                    }
                }
                
                completionHandler(results, nil)
            } else {
                completionHandler([nil], error)
            }
        }
        
    }
    
    
    //MARK - getDataFromCurrentUser
    func getDataFromCurrentUser(password:String,completionHandler: @escaping (Error?) -> Void) {
        
        let userRef = db.collection(FIRCollectionReference.users).whereField("id", isEqualTo: (Auth.auth().currentUser?.uid)!)
        
        userRef.getDocuments(source: .default) { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let user = User()
                    user.creationDate = document["creationDate"] as? String
                    user.id = document["id"] as? String
                    user.email = document["email"] as? String
                    user.firstName = document["firstName"] as? String
                    user.lastName = document["lastName"] as? String
                    user.phone = document["phone"] as? String
                    user.whatsapp = document["whatsapp"] as? String
                    user.businessesIds = document["businessesIds"] as? [String]
                    user.favoritesIds  = document["favoritesIds"] as? [String]
                    user.password = password
                    
                    let imageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(user.id!)
                    imageRef.downloadURL { (url, error) in
                        
                        do {
                            let data = try Data(contentsOf: url!)
                            user.image = UIImage(data: data as Data)
                            
                            //set the global variable with current user
                            self.appDelegate.userObj = user
                            CoreDataService.shared.saveCurrentUserToCoreData()
                            CoreDataService.shared.readCurrentUserFromCoreData()
                            completionHandler(nil)
                        } catch {
                            completionHandler(error)
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteAccount() {
        
        //Remove user from Firebase Account
        Auth.auth().currentUser?.delete(completion: { (error) in
            if error == nil {
                print("usuário deletado com sucesso")
            }
        })
        
        
        //Remove user from Storage
        let imageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(appDelegate.userObj.id)
        imageRef.delete { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("foto usuario removido storage")
            }
        }
        
        //Remove user from Firestore Collection
        let userRef = db.collection(FIRCollectionReference.users)
        userRef.document(appDelegate.userObj.id).delete { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("usuário removido firebase")
            }
        }
        
        //Remove user from CoreData
        CoreDataService.shared.resetAllRecordsOnCoreData()
        
        //Remove user from AppDelegate
        appDelegate.userObj.resetValuesOfUserAccount()
        
    }
    
}

