//
//  CreateAccountViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos
import KRProgressHUD

class CreateAccountViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //check if the e-mail and password are okay
        self.tfEmail.addTarget(self, action: #selector(self.textFieldCheckEmail(_:)), for: .editingChanged)
        self.tfPassword.addTarget(self, action: #selector(self.textFieldCheckMinPassword(_:)), for: .editingChanged)
        self.tfPasswordConfirm.addTarget(self, action: #selector(self.textFieldCheckMinPassword(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    //MARK - SetupUI
    func setupUI(){
        btnCreateAccount?.layer.cornerRadius = 15
        btnCreateAccount?.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        
        //Checks if the required fields are empty.
        guard tfFirstName.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfEmail.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfPassword.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfPasswordConfirm.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        
        guard tfPassword.text == tfPasswordConfirm.text else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordDontMatch);
            return
        }
        
        KRProgressHUD.show(withMessage: NSLocalizedString(LocalizationKeys.pleaseWait, comment: "")) {
            
            //set all information to user object
            self.appDelegate.userObj.firstName = self.tfFirstName.text
            self.appDelegate.userObj.lastName = self.tfLastName.text
            self.appDelegate.userObj.email = self.tfEmail.text
            self.appDelegate.userObj.password = self.tfPassword.text
            self.appDelegate.userObj.image = self.profileImageView.image
            self.appDelegate.userObj.creationDate = Service.shared.getTodaysDate()

            
            FIRFirestoreService.shared.createUser { (error) in
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                        KRProgressHUD.dismiss()
                        self.showAlert(errorCode: errCode)
                    }
                } else {
                    let alert = UIAlertController(title: General.congratulations, message: General.successfully, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "unWindToMenuVC", sender: nil)
                    }))
                    KRProgressHUD.dismiss()
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnChangeImage(_ sender: Any) {
        
        Service.shared.checkPermissionPhotoLibrary { (status) in
            if status == .authorized {
                
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
            } else {
                
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 10)
                
                let alert = UIAlertController(title: General.warning, message: General.warningPhotoCameraDenied, preferredStyle: .alert)
                alert.setValue(vc, forKey: "contentViewController")
                
                alert.addAction(UIAlertAction(title: General.OK, style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            }
        }
    }
}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
