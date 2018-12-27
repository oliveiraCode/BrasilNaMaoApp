//
//  MenuViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class  MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var btnSignInOut: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var img_login_logout: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nameMenu:[String] = [NSLocalizedString("Home", comment: "Home"),
                             NSLocalizedString("My Ad", comment: "MyAd"),
                             NSLocalizedString("Events", comment: "Events"),
                             NSLocalizedString("Tips", comment: "Tips"),
                             NSLocalizedString("Share", comment: "Share"),
                             NSLocalizedString("Settings", comment: "Settings"),
                             NSLocalizedString("Contact us", comment: "Contact us"),
                             NSLocalizedString("About", comment: "About")]
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //StatusBar white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleNavigatorBar()
        setupImgProfile()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - Setup ViewController
    func setupImgProfile(){
        imgProfile.layer.cornerRadius = imgProfile.bounds.height / 2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.clipsToBounds = true
    }
    
    func changeTitleNavigatorBar(){
        let logo = UIImage(named: "logoTitle")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nameMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath)
        
        let imgMenu = cell.contentView.viewWithTag(100) as! UIImageView
        let nameMenu = cell.contentView.viewWithTag(101) as! UILabel
        
       // imgMenu.image = UIImage(named:self.imgMenu[indexPath.row])
        nameMenu.text = self.nameMenu[indexPath.row]
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showHomeVC", sender: nil)
        case 1:
            performSegue(withIdentifier: "showMyAdVC", sender: nil)
        case 2:
            performSegue(withIdentifier: "showEventsVC", sender: nil)
        case 3:
            performSegue(withIdentifier: "showTipsVC", sender: nil)
        case 4:
            performSegue(withIdentifier: "showShareVC", sender: nil)
        case 5:
            performSegue(withIdentifier: "showSettingsVC", sender: nil)
        case 6:
            performSegue(withIdentifier: "showContactUsVC", sender: nil)
        case 7:
            performSegue(withIdentifier: "showAboutVC", sender: nil)
        default:
            print("done")
        }
        
    }
    
    

    
    
    
}
