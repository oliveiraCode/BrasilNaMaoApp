//
//  MyAdViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Firebase

class MyBusinessViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate  {
    
    //IBOutlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfComplement: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfProvince: UITextField!
    @IBOutlet weak var tfPostalCode: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfWhatsapp: UITextField!
    @IBOutlet weak var tfWeb: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryValue:String?
    var indexPathItemForImage:Int?
    var imageArrayForStorage:[UIImage] = [UIImage(named: "placeholder_photo_new_ad")!,
                                          UIImage(named: "placeholder_photo_new_ad")!,
                                          UIImage(named: "placeholder_photo_new_ad")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryValue == nil {
            btnCategory.setTitle(LocalizationKeys.buttonSelectCategory, for: .normal)
        } else {
            btnCategory.setTitle(self.categoryValue, for: .normal)
        }
        
        pageControl.numberOfPages = self.imageArrayForStorage.count
        setLayoutUITextView()
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCategoryVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destController = navController.topViewController as! CategoryTableViewController
        destController.delegate = self
        
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard let description = tvDescription.text else {return}
        guard let name = tfName.text else {return}
        
        guard let street = tfStreet.text else {return}
        guard let complement = tfComplement.text else {return}
        guard let city = tfCity.text else {return}
        guard let province = tfProvince.text else {return}
        guard let postalCode = tfPostalCode.text else {return}
        
        guard let email = tfEmail.text else {return}
        guard let phone = tfPhone.text else {return}
        guard let whatsapp = tfWhatsapp.text else {return}
        guard let web = tfWeb.text else {return}
        guard let category = btnCategory.title(for: .normal) else {return}
        
        
        Service.shared.getCoordinateFromGeoCoder(address: "\(street), \(city), \(province) \(postalCode)") { (coordinate, error) in
            
            if error == nil {
                let contact:Contact = Contact(email: email, phone: phone,whatsapp: whatsapp, web: web)
                
                let address:Address = Address(street: street, complement: complement, city: city, province: province, postalCode: postalCode, latitude: coordinate!.coordinate.latitude, longitude: coordinate!.coordinate.longitude)
                
                let hoursArray = [DailyHours]()
                
                let business = Business(description: description, name: name,rating: 0.0, address: address, contact: contact, creationDate: Service.shared.getTodaysDate(), category: category, user_id: (UIApplication.shared.delegate as! AppDelegate).userObj.id, hours:hoursArray)
                
                FIRFirestoreService.shared.saveBusinessToFirestore(business: business, imageArray: self.imageArrayForStorage)
                
                self.showAlert(title: General.congratulations, message: General.businessCreated)
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("error \(error!.localizedDescription)")
            }
        }
        
    }
    
    
    
    //MARK -> PickImage's method
    @objc func pickImage(_ sender:AnyObject) {
        
        indexPathItemForImage = sender.view.tag //to know witch item was selected.
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCamera, style: .default, handler: { action in
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonPhotoLibrary, style: .default, handler: { action in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK -> CollectionView's methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArrayForStorage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMyBusinessCell", for: indexPath) as! MyBusinessCollectionViewCell
        
        cell.imageCellBusiness.image = imageArrayForStorage[indexPath.item]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
        cell.imageCellBusiness.isUserInteractionEnabled = true
        cell.imageCellBusiness.tag = indexPath.row
        cell.imageCellBusiness.addGestureRecognizer(tapGestureRecognizer)
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        
    }
    
    //MARK - UITextView setup
    func setLayoutUITextView(){
        //That code was inspired from https://stackoverflow.com/questions/27652227/text-view-placeholder-swift
        //to put placeholder into TextView, the textViewDidBeginEditing and textViewDidEndEditing must be implemented together.
        tvDescription.delegate = self
        tvDescription.text = Placeholders.placeholder_descricao
        tvDescription.textColor = UIColor.lightGray
        
        
        //to make a border on TextView
        tvDescription.layer.borderWidth = 0.3
        tvDescription.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvDescription.textColor == UIColor.lightGray {
            tvDescription.text = nil
            tvDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescription.text.isEmpty {
            tvDescription.text = Placeholders.placeholder_descricao
            tvDescription.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            
            if appDelegate.userObj.email != nil {
                tfEmail.isEnabled = false
                tfEmail.text = appDelegate.userObj.email
            }
            if appDelegate.userObj.phone != nil {
                tfPhone.isEnabled = false
                tfPhone.text = appDelegate.userObj.phone
            }
            if appDelegate.userObj.whatsapp != nil {
                tfWhatsapp.isEnabled = false
                tfWhatsapp.text = appDelegate.userObj.whatsapp
            }
            
        } else {
            tfEmail.isEnabled = true
            tfPhone.isEnabled = true
            tfWhatsapp.isEnabled = true
            tfEmail.text = ""
            tfPhone.text = ""
            tfWhatsapp.text = ""
        }
        
    }
    
    
}


extension MyBusinessViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        self.categoryValue = categoryValue
    }
    
}

extension MyBusinessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageArrayForStorage.remove(at: indexPathItemForImage!)
            imageArrayForStorage.insert(pickedImage, at: indexPathItemForImage!)
            
        }
        picker.dismiss(animated: true, completion: {self.collectionView.reloadData()})
    }
    
}
