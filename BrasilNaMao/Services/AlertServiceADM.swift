//
//  AlertServiceADM.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class AlertServiceADM {
    private init(){}
    
    static func addCategory(in vc: UIViewController, completion: @escaping (Category) -> Void) {
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "Name of category"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else {return}
            
            let category = Category(name: name)
            completion(category)
        }
        alert.addAction(add)
        vc.present(alert, animated: true)
    }
}
