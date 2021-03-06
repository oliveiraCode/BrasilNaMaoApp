//
//  BusinessesTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import SWRevealViewController
import Kingfisher

class BusinessesTableViewController: UITableViewController {
    
    //IBOutlets
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    //Properties
    var indicator = UIActivityIndicatorView()
    var businesses = [Business]()
    var businessIndexPathSelected : Int!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var refreshTableView: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando")
        
        return refreshControl
    }()
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        updateTableViewWithDataFromFirebase()
        refreshTableView.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = refreshTableView
        
        let nibName = UINib(nibName: "BusinessCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BusinessCell")
        
        sideMenus()
        activityIndicator()
        updateTableViewWithDataFromFirebase()
        
    }
    
    func updateTableViewWithDataFromFirebase(){
        
        indicator.startAnimating()
        FIRFirestoreService.shared.readMyBusinesses { (business, error) in
            if business as? [Business] == nil {
                self.businesses.removeAll()
            }else{
                self.businesses = business as! [Business]
            }
            self.tableView.reloadData()
        }
        indicator.stopAnimating()
    }
    
    
    @IBAction func btnNewBusiness(_ sender: UIBarButtonItem) {
        
        if appDelegate.userObj.id == nil {
            
            let alert = UIAlertController(title: "", message: CommonWarning.errorNewBusiness, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonLogin, style: .default, handler: { action in
                self.performSegue(withIdentifier: "showLoginVC", sender: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "showNewBusinessVC", sender: nil)
        }
        
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
            
            cell.lbAddress.text = self.businesses[indexPath.row].address?.city!
            
            cell.lbCategory.text = self.businesses[indexPath.row].category
            cell.lbName.text = self.businesses[indexPath.row].name
            cell.ratingCosmosView.rating = self.businesses[indexPath.row].rating!
            
            cell.imgLogo.kf.setImage(
                with: URL(string: self.businesses[indexPath.row].photosURL![0]),
                placeholder: UIImage(named: Placeholders.placeholder_photo),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            cell.lbDistance.text = String(format:"%.2f km ",(businesses[indexPath.row].address?.distance)!)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        businessIndexPathSelected = indexPath.row
        performSegue(withIdentifier: "showDetailsBusinessVC", sender: nil)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar") { (contextualAction, view, success) in
            
            //remove photos from storage
            FIRFirestoreService.shared.removeMyBusinessStorage(business: self.businesses[indexPath.row])
            
            //remove business from database
            FIRFirestoreService.shared.removeMyBusinessData(business: self.businesses[indexPath.row])
            
            //remove business from TableView
            self.businesses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            success(true)
        }
        
        
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, success) in
            
            self.businessIndexPathSelected = indexPath.row
            self.performSegue(withIdentifier: "showEditBusinessVC", sender: nil)
            
            success(false)
        }
        
        
        //set color and image
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(named: "edit_business")
        editAction.backgroundColor = .blue
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsBusinessVC" {
            let destController = segue.destination as! DetailsBusinessViewController
            destController.businessDetails = businesses[businessIndexPathSelected]
        }
        
        if segue.identifier == "showNewBusinessVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! MyBusinessViewController
            destController.isNewBusiness = true
        }
        
        if segue.identifier == "showEditBusinessVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! MyBusinessViewController
            destController.businessDetails = businesses[businessIndexPathSelected]
            destController.isNewBusiness = false
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
    
    //MARK: - Activity Indicator
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
}
