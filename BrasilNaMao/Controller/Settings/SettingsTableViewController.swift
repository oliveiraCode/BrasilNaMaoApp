//
//  RecommendationTableViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    //to know more https://medium.com/@mimicatcodes/create-unwind-segues-in-swift-3-8793f7d23c6f
    @IBAction func unWindToSettings(segue:UIStoryboardSegue) {}
    
    
    let img0:[UIImage] = [UIImage(named: "account_color")!]
    let settings0:[String] = [NSLocalizedString(LocalizationKeys.settingsAccount, comment: "")]
    
    let img1:[UIImage] = [UIImage(named: "terms_color")!,
                          UIImage(named: "privacy_color")!]
    let settings1:[String] = [NSLocalizedString(LocalizationKeys.settingsTermsOfUse, comment: ""),
                              NSLocalizedString(LocalizationKeys.settingsPrivacy, comment: "")]
    
    let img2:[UIImage] = [UIImage(named: "share_color")!,
                          UIImage(named: "contact_us_color")!,
                          UIImage(named: "about_color")!]
    let settings2:[String] = [NSLocalizedString(LocalizationKeys.settingsShare, comment: ""),
                              NSLocalizedString(LocalizationKeys.settingsContactUs, comment: ""),
                              NSLocalizedString(LocalizationKeys.settingsAbout, comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return self.settings0.count
        } else if section == 1 {
            return self.settings1.count
        } else {
            return self.settings2.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        if indexPath.section == 0 {
            cell.lbSettings.text = self.settings0[indexPath.row]
            cell.imgSettings.image = self.img0[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell.lbSettings.text = self.settings1[indexPath.row]
            cell.imgSettings.image = self.img1[indexPath.row]
        }
        
        if indexPath.section == 2 {
            cell.lbSettings.text = self.settings2[indexPath.row]
            cell.imgSettings.image = self.img2[indexPath.row]
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if (UIApplication.shared.delegate as! AppDelegate).userObj.id != nil {
                    performSegue(withIdentifier: "showProfileVC", sender: nil)
                } else {
                    self.showAlert(title: "", message: LocalizationKeys.accessProfile)
                }
                break
            default:
                print("done")
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("termos de uso")
                break
            case 1:
                print("política de privacidade")
                break
            default:
                print("done")
            }
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                print("compartilhar")
                break
            case 1:
                print("fale conosco")
                break
            case 2:
                print("sobre")
                break
            default:
                print("done")
            }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK - SideMenu Method
    func sideMenus() {
        if revealViewController() != nil {
            
            self.btnMenu.target = revealViewController()
            self.btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
}
