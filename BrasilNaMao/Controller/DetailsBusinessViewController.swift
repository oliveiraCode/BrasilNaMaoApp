//
//  DetailsBusinessViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
import CoreLocation

class DetailsBusinessViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MKMapViewDelegate {
    
    //IBOutlets
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnWhatsApp: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var map: MKMapView!
    
    
    //Properties
    var businessDetails = Business()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setValuesToUI()
        setAnnotationsOnTheMap()
        
        //set border to TextView
        tvDescription.layer.borderWidth = 0.6
        tvDescription.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    //MARK - Set values to UI
    func setValuesToUI(){

        self.lbName.text = businessDetails.name
        self.cvRating.rating = businessDetails.rating!
        self.lbCategory.text = businessDetails.category
        self.lbAddress.text = getAddressFormatted()
        self.tvDescription.text = businessDetails.description
        self.btnEmail.setTitle(businessDetails.contact?.email, for: .normal)
        self.btnPhone.setTitle(businessDetails.contact?.phone, for: .normal)
        self.btnWhatsApp.setTitle(businessDetails.contact?.whatsapp, for: .normal)
        self.btnFacebook.setTitle(businessDetails.contact?.web, for: .normal)
        self.pageControl.numberOfPages = 3
        
    }
    
    
    private func getAddressFormatted() -> String {
        
        let street = (businessDetails.address?.street)!
        let complement = (businessDetails.address?.complement)!
        let city = (businessDetails.address?.city)!
        let province = (businessDetails.address?.province?.uppercased())!
        let postalCode = (businessDetails.address?.postalCode?.uppercased())!
        
        return "\(street) \(complement), \(city), \(province) \(postalCode)"
    }
    
    //MARK - Set annotations on the map
    func setAnnotationsOnTheMap(){
        let businessLocation = CLLocationCoordinate2D(latitude: (businessDetails.address?.latitude)!, longitude: (businessDetails.address?.longitude)!)
        
        //Radius in Meters
        let regionRadius: CLLocationDistance = 800
        
        //Create a Map region
        let coordinateRegion = MKCoordinateRegion(center: businessLocation,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //set mapView to the region specified
        map.setRegion(coordinateRegion, animated: true)
        
        //set business location with constructor before call addAnnotation
        let businessAnnotation = BusinessAnnotation(title: "\(businessDetails.name!)", coordinate: businessLocation)
        
        self.map.addAnnotation(businessAnnotation)
    }
    
    //MARK - CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionDetailsBusinessCell", for: indexPath) as! DetailsBusinessCollectionViewCell
        
        FIRFirestoreService.shared.readImageFromStorage(business: self.businessDetails, indexImage: indexPath.item+1) { (url, error) in
            
            cell.imageCellBusiness.kf.setImage(
                with: url,
                placeholder: UIImage(named: Placeholders.placeholder_photo),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
        }
        
        //image corner with some radius
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "unWindToListVC", sender: nil)
    }
    
    @IBAction func btnPhone(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text else {return}
        
        let formattedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let phoneNumberURLString = "tel://\(formattedNumber)"
        if let phoneNumberURL = URL(string: phoneNumberURLString) {
            UIApplication.shared.open(phoneNumberURL, options: [:], completionHandler: nil)
        }
        else {
            self.showAlert(title: General.warning, message: CommonWarning.errorMessageInvalidPhone)
        }
    }
    
    @IBAction func btnWhatsApp(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text else {return}
        
        let formattedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if let phoneNumberURL = URL(string: "https://api.whatsapp.com/send?phone=\(formattedNumber)") {
            UIApplication.shared.open(phoneNumberURL, options: [:], completionHandler: nil)
        }
        else {
            self.showAlert(title: General.warning, message: CommonWarning.errorMessageInvalidPhone)
        }
    }
    
    @IBAction func btnEmail(_ sender: UIButton) {
        guard let email = sender.titleLabel?.text else {return}
        
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }else{
            self.showAlert(title: General.warning, message: CommonWarning.errorEmail)
        }
    }
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        guard let website = sender.titleLabel?.text else {return}
        
        if let url = URL(string: "http://\(website)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
               self.showAlert(title: General.warning, message: CommonWarning.errorWebSite)
            }
        }
        
    }
    
}
