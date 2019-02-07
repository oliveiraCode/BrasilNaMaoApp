//
//  ViewController Extensions.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-23.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(errorCode: AuthErrorCode){
        
        let alert = UIAlertController(title: FirebaseAuthErrors.warning, message: "", preferredStyle: .alert)
        
        switch errorCode {
        case .emailAlreadyInUse:
            alert.message = FirebaseAuthErrors.emailAlreadyInUse
            break
        case .invalidEmail:
            alert.message = FirebaseAuthErrors.invalidEmail
            break
        case .wrongPassword:
            alert.message = FirebaseAuthErrors.wrongPassword
            break
        case .weakPassword:
            alert.message = FirebaseAuthErrors.weakPassword
            break
        case .userNotFound:
            alert.message = FirebaseAuthErrors.userNotFound
            break
        case .userDisabled:
            alert.message = FirebaseAuthErrors.userDisabled
            break
        case .networkError:
            alert.message = FirebaseAuthErrors.networkError
            break
        // TODO: A case for if the password field is blank
        default:
            alert.message = FirebaseAuthErrors.errorDefault
        }
        
        alert.addAction(UIAlertAction(title: General.OK, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func showAlert(title:String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldCheckEmail(_ textfield: UITextField) {
        
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if !text.contains("@") {
                    floatingLabelTextField.errorMessage = "E-mail inválido"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldCheckMinPassword(_ textfield: UITextField) {
        
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if text.count < 6 && text.count > 0 {
                    floatingLabelTextField.errorMessage = "Mínino 6 caracteres"
                } else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
}




