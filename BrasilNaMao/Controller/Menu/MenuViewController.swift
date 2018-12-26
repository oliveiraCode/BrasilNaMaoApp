//
//  MenuViewController.swift
//  LifeHome
//
//  Created by Leandro Oliveira on 2018-05-31.
//  Copyright © 2018 Leandro Oliveira. All rights reserved.
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
    let nameMenu:[String] = [NSLocalizedString("Tela Inicial", comment: "Home"),
                             NSLocalizedString("Meu Anuncio", comment: "MyAd"),
                             NSLocalizedString("Eventos", comment: "Events"),
                             NSLocalizedString("Recomendações", comment: "Recomendations"),
                             NSLocalizedString("Compartilhar", comment: "Share"),
                             NSLocalizedString("Configuração", comment: "Settings"),
                             NSLocalizedString("Fale Conosco", comment: "Contact us"),
                             NSLocalizedString("Sobre", comment: "About")]
    
    
    
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
       
        if indexPath.row == 0  {
            performSegue(withIdentifier: "showHomeVC", sender: nil)
        }
        
        if indexPath.row == 1  {
            performSegue(withIdentifier: "showProfileVC", sender: nil)
        }
        
        if indexPath.row == 2  {
            performSegue(withIdentifier: "showSettingsVC", sender: nil)
        }
        
        if indexPath.row == 3  {
            performSegue(withIdentifier: "showAboutVC", sender: nil)
        }
        
    }
    
    

    
    
    
}
