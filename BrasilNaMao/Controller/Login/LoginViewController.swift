//
//  LoginViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class LoginViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //check if the e-mail and password are okay
        self.tfEmail.addTarget(self, action: #selector(self.textFieldCheckEmail(_:)), for: .editingChanged)
        self.tfPassword.addTarget(self, action: #selector(self.textFieldCheckMinPassword(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    //MARK - SetupUI
    func setupUI(){
        btnLogin?.layer.cornerRadius = 15
        btnLogin?.layer.masksToBounds = true
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        guard let email = tfEmail.text else {return}
        guard let password = tfPassword.text else {return}
        
        //check if they have value
        guard email != "" else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailEmpty);
            return
        }
        guard password != ""  else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordEmpty);
            return
        }
        
        KRProgressHUD.show(withMessage: NSLocalizedString(LocalizationKeys.pleaseWait, comment: "")) {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                        KRProgressHUD.dismiss()
                        self.showAlert(errorCode: errCode)
                    }
                } else {
                    FIRFirestoreService.shared.getDataFromCurrentUser(password:password,completionHandler: { (error) in
                        if error == nil {
                            KRProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func btnLoginNotNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        guard let email = tfEmail.text else {return}
        
        //check if they have value
        guard email != "" else {self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailResetPassword); return}
        
        //Show Activity Indicator
        KRProgressHUD.show(withMessage: NSLocalizedString(LocalizationKeys.pleaseWait, comment: "")) {
            
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                        KRProgressHUD.dismiss()
                        self.showAlert(errorCode: errCode)
                    }
                }else {
                    KRProgressHUD.dismiss()
                    self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailSentResetPassword)
                }
            }
        }
    }
    
    
    
}
