//
//  FIRFirestoreService.swift
//  KDBrasil
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
    var currentCity:String?
    
    //MARK: - saveData
    func saveData(business:Business, imageArray:[UIImage]){
        var photoUrls:[String] = []
        
        let businessRef = Firestore.firestore().collection(FIRCollectionReference.business)
        business.id = businessRef.document().collection(businessRef.collectionID).document().documentID
        
        for (index,image) in imageArray.enumerated() {
        
            uploading(business: business, img: image, index: index) { (url) in
                photoUrls.append(url)

                if photoUrls.count == 3 {
                    business.photosURL = photoUrls.sorted{ $0 < $1 }
                    self.saveBusinessToFirestore(businessRef: businessRef, business: business)
                }
            }
        }
    }
    
    
    func uploading(business:Business,img:UIImage, index:Int, completion: @escaping ((String) -> Void)) {
        
        let storeImage = Storage.storage().reference().child(FIRCollectionReference.imageBusiness).child("\(business.id!)\(index)")
        
        if let uploadImageData = (img).jpegData(compressionQuality: 0.75){
            storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        completion(urlText)
                    }
                })
            })
        }
    }
    
    
    //MARK - saveBusinessToFirestore
    private func saveBusinessToFirestore (businessRef:CollectionReference, business:Business){
        
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
                "number": business.address!.number!,
                "street": business.address!.street!,
                "complement": business.address!.complement!,
                "latitude":business.address!.latitude!,
                "longitude":business.address!.longitude!
            ]
        }
        
        
        var day0: [String:Any]{
            return [
                "day": business.hours![0].day!,
                "start": business.hours![0].start!,
                "end": business.hours![0].end!,
                "is_closed": business.hours![0].is_closed!,
                "is_overnight": business.hours![0].is_overnight!
            ]
        }
        
        var day1: [String:Any]{
            return [
                "day": business.hours![1].day!,
                "start": business.hours![1].start!,
                "end": business.hours![1].end!,
                "is_closed": business.hours![1].is_closed!,
                "is_overnight": business.hours![1].is_overnight!
            ]
        }
        
        var day2: [String:Any]{
            return [
                "day": business.hours![2].day!,
                "start": business.hours![2].start!,
                "end": business.hours![2].end!,
                "is_closed": business.hours![2].is_closed!,
                "is_overnight": business.hours![2].is_overnight!
            ]
        }
        
        var day3: [String:Any]{
            return [
                "day": business.hours![3].day!,
                "start": business.hours![3].start!,
                "end": business.hours![3].end!,
                "is_closed": business.hours![3].is_closed!,
                "is_overnight": business.hours![3].is_overnight!
            ]
        }
        
        var day4: [String:Any]{
            return [
                "day": business.hours![4].day!,
                "start": business.hours![4].start!,
                "end": business.hours![4].end!,
                "is_closed": business.hours![4].is_closed!,
                "is_overnight": business.hours![4].is_overnight!
            ]
        }
        
        var day5: [String:Any]{
            return [
                "day": business.hours![5].day!,
                "start": business.hours![5].start!,
                "end": business.hours![5].end!,
                "is_closed": business.hours![5].is_closed!,
                "is_overnight": business.hours![5].is_overnight!
            ]
        }
        
        var day6: [String:Any]{
            return [
                "day": business.hours![6].day!,
                "start": business.hours![6].start!,
                "end": business.hours![6].end!,
                "is_closed": business.hours![6].is_closed!,
                "is_overnight": business.hours![6].is_overnight!
            ]
        }
        
        var hoursData: [String: Any] {
            return [
                "0" : day0,
                "1" : day1,
                "2" : day2,
                "3" : day3,
                "4" : day4,
                "5" : day5,
                "6" : day6
            ]
        }
        
        var businessData: [String: Any] {
            return [
                "id":business.id!,
                "description": business.description!,
                "name": business.name!,
                "creationDate": business.creationDate!,
                "category": business.category!,
                "user_id": business.user_id!,
                "rating": business.rating!,
                "address":addressData,
                "hours":hoursData,
                "contact":contactData,
                "photosURL":business.photosURL!
            ]
        }
        
        
        
        businessRef.document(business.id!).setData(businessData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved")
            }
        }
        
    }
    
    //MARK - removeMyBusiness
    func removeMyBusinessData(business:Business){
        
        db.collection(FIRCollectionReference.business).document("\(business.id!)").delete()
    }
    
    //MARK - removeMyBusinessStorage
    func removeMyBusinessStorage(business:Business) {
      
        //remove each image from store
        
        for (index,_) in (business.photosURL?.enumerated())!{
            let storeImage = Storage.storage().reference().child(FIRCollectionReference.imageBusiness).child("\(business.id!)\(index)")
            
            storeImage.delete { (error) in
                if error != nil {
                    print("error \(error!.localizedDescription)")
                } else {
                    print("foto anúncio removido do storage")
                }
            }
            
        }
        
    }
    
    //MARK - readMyBusinesses
    func readMyBusinesses(completionHandler: @escaping ([Business?], Error?) -> Void) {
        
        guard let userID = appDelegate.userObj.id else {
            completionHandler([nil],nil)
            return}
        
        let businessRef = db.collection(FIRCollectionReference.business).whereField("user_id", isEqualTo: "\(userID)")
        
        var businesses = [Business]()
        
        businessRef.order(by: "creationDate", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler([nil],err)
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let address = document.data()["address"] as! [String:Any]
                    let contact = document.data()["contact"] as! [String:Any]
                    let hours = document.data()["hours"] as! [String:Any]
                    
                    let addressObj = Address(data: address)
                    
                    addressObj?.distance = Service.shared.calculateDistanceKm(lat: (addressObj!.latitude)!, long: (addressObj!.longitude)!)
                    
                    let contactObj = Contact(data: contact)
                    
                    var dailyHoursArray:[DailyHours] = []
                    for (_, value) in hours.values.enumerated(){
                        
                        let dailyHoursObj = value as! [String:Any]
                        dailyHoursArray.append(DailyHours(data: dailyHoursObj)!)
                    }
                    
                    let businessObj = Business(data: document.data(), addressObj: addressObj!, contactObj: contactObj!, dailyHoursArray: dailyHoursArray)
                    
                    
                    businesses.append(businessObj!)
                }
                
                let newArrayOfBusiness =  businesses.sorted { $0.address!.distance! < $1.address!.distance! }
                
                completionHandler(newArrayOfBusiness,nil)
            }
        }
    }
    
    //MARK: - readAllBusiness
    func readAllBusiness(completionHandler: @escaping ([Business?], Error?) -> Void) {
        
        let businessRef = self.db.collection(FIRCollectionReference.business)
        var businesses = [Business]()
        
        businessRef.order(by: "name", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler([nil],err)
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let address = document.data()["address"] as! [String:Any]
                    let contact = document.data()["contact"] as! [String:Any]
                    let hours = document.data()["hours"] as! [String:Any]
                    
                    let addressObj = Address(data: address)
                    
                    addressObj?.distance = Service.shared.calculateDistanceKm(lat: (addressObj!.latitude)!, long: (addressObj!.longitude)!)
                    
                    let contactObj = Contact(data: contact)
                    
                    var dailyHoursArray:[DailyHours] = []
                    for (_, value) in hours.values.enumerated(){
                        let dailyHoursObj = value as! [String:Any]
                        dailyHoursArray.append(DailyHours(data: dailyHoursObj)!)
                    }
                    let businessObj = Business(data: document.data(), addressObj: addressObj!, contactObj: contactObj!, dailyHoursArray: dailyHoursArray)
                    
                    businesses.append(businessObj!)
                }
                let newArrayOfBusiness =  businesses.sorted { $0.address!.distance! < $1.address!.distance! }
                
                completionHandler(newArrayOfBusiness,nil)
            }
        }
    }
    
    
    
    
    
    //MARK: - createUser
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
    
    //MARK: - saveImageToStorage
    func saveImageToStorage(){
        
        guard let imageData = appDelegate.userObj.image.jpegData(compressionQuality: 0.75) else {return}
        
        let storageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(appDelegate.userObj.id!)
  
        storageRef.putData(imageData, metadata: nil)
        print("Image Uploaded successfully")
        
    }
    
    //MARK: - saveProfileToFireStore
    func saveProfileToFireStore() {
        
        let userRef = db.collection(FIRCollectionReference.users)
        
        var userData: [String: Any] {
            return [
                "id":appDelegate.userObj.id,
                "firstName": appDelegate.userObj.firstName,
                "lastName": appDelegate.userObj.lastName ?? "",
                "email": appDelegate.userObj.email,
                "phone": appDelegate.userObj.phone ?? "",
                "whatsapp": appDelegate.userObj.whatsapp ?? "",
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
                    
                    if let category = Category(dictionary: document.data(), opened: true, title: "a") {
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
                    
                    let user = User(data: document.data(), password: password)
                    
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
    
    
    //MARK - getDataFromUserBusiness
    func getDataFromUserBusiness(idUser:String,completionHandler: @escaping (User?,Error?) -> Void) {
        
        let userRef = db.collection(FIRCollectionReference.users).whereField("id", isEqualTo: idUser)
        
        userRef.getDocuments(source: .default) { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(nil,err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let user = User()
                    user.creationDate = document["creationDate"] as? String
                    user.firstName = document["firstName"] as? String
                    
                    let imageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(idUser)
                    imageRef.downloadURL { (url, error) in
                        
                        do {
                            let data = try Data(contentsOf: url!)
                            user.image = UIImage(data: data as Data)
                            
                            completionHandler(user,nil)
                        } catch {
                            completionHandler(nil,error)
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

