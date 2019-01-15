//
//  SettingsViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        print("categoria")
        AlertServiceADM.addCategory(in: self) { category in
            print(category)
            FIRFirestoreService.shared.createCategory(for: category, in: .category)
        }
    }
    //MARK - SideMenu Method
    func sideMenus() {
        if revealViewController() != nil {
            
            self.btnMenu.target = revealViewController()
            self.btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

}
