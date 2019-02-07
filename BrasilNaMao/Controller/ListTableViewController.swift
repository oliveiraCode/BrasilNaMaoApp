//
//  ListTableViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-30.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import SWRevealViewController
import Kingfisher

class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBAction func unWindToList(segue:UIStoryboardSegue) {}
    var businesses = [Business]()
    var businessIndexPathSelected : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "BusinessCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BusinessCell")
        
        sideMenus()
        
        FIRFirestoreService.shared.readAllBusiness { (business, error) in
            self.businesses = business as! [Business]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.businesses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        if self.businesses.count > 0 {

            cell.lbAddress.text = (self.businesses[indexPath.row].address?.street)!+", "+(self.businesses[indexPath.row].address?.city)!
            
            cell.lbCategory.text = self.businesses[indexPath.row].category
            cell.lbName.text = self.businesses[indexPath.row].name
            cell.ratingCosmosView.rating = self.businesses[indexPath.row].rating!
            
            FIRFirestoreService.shared.readImageFromStorage(business: self.businesses[indexPath.row], indexImage: 1) { (url, error) in
        
                cell.imgLogo.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: Placeholders.placeholder_photo),
                    options: [
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }

            cell.lbDistance.text = String(format:"%.2f km ",Service.shared.calculateDistanceKm(lat: (businesses[indexPath.row].address?.latitude)!, long: (businesses[indexPath.row].address?.longitude)!))

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        businessIndexPathSelected = indexPath.row
        performSegue(withIdentifier: "showDetailsBusinessVC", sender: nil)
       
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
//        if segue.identifier == "showDetailsBusinessVC" {
//
//            let navController = segue.destination as! UINavigationController
//            let destController = navController.topViewController as! DetailsBusinessViewController
//            destController.businessDetails = businesses[businessIndexPathSelected]
//        }
        
        if segue.identifier == "showDetailsBusinessVC" {
            
            let destController = segue.destination as! DetailsBusinessViewController
            destController.businessDetails = businesses[businessIndexPathSelected]
        }
     }
 
    
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
