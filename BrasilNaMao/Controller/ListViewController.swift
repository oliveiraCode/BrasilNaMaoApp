//
//  ListTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-30.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import SWRevealViewController
import Kingfisher
import KRActivityIndicatorView

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //IBOoutlets
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Properties
    var indicator = UIActivityIndicatorView()
    var businesses = [Business]()
    var businessesFiltered = [Business]()
    var selectedSegmentIndex = 0 //value dafault is name
    var businessIndexPathSelected : Int!
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
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func updateTableViewWithDataFromFirebase(){
        
        indicator.startAnimating()
        FIRFirestoreService.shared.readAllBusiness { (business, error) in
            self.businesses = business as! [Business]
            self.businessesFiltered = self.businesses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        indicator.stopAnimating()
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.businesses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        businessIndexPathSelected = indexPath.row
        performSegue(withIdentifier: "showDetailsBusinessVC", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsBusinessVC" {
            let destController = segue.destination as! DetailsBusinessViewController
            destController.businessDetails = businesses[businessIndexPathSelected]
        }
    }
    
    
    //MARK: - SideMenu Method
    func sideMenus() {
        if revealViewController() != nil {
            
            self.btnMenu.target = revealViewController()
            self.btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    //MARK: - Methods Segmented Control
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        //set the placeholder on searchBar
        selectedSegmentIndex = sender.selectedSegmentIndex
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = Placeholders.searchByName
            break
        case 1:
            searchBar.placeholder = Placeholders.searchByCategory
            break
        case 2:
            searchBar.placeholder = Placeholders.searchByCity
            break
        default:
            break
        }
        self.searchBar.text = ""
    }
    
}

extension ListViewController: UISearchBarDelegate {
    
    //MARK: - Methods SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        indicator.startAnimating()
        switch selectedSegmentIndex {
        case 0:
            self.businesses = self.businessesFiltered.filter({ Business -> Bool in
                if searchText.isEmpty { return true }
                return (Business.name!.lowercased().contains(searchText.lowercased()))
            })
            break
        case 1:
            self.businesses = self.businessesFiltered.filter({ Business -> Bool in
                if searchText.isEmpty { return true }
                return (Business.category!.lowercased().contains(searchText.lowercased()))
            })
            break
        case 2:
            
            self.businesses = self.businessesFiltered.filter({ Business -> Bool in
                if searchText.isEmpty { return true }
                return (Business.address!.city!.lowercased().contains(searchText.lowercased()))
            })
            break
        default:
            break
        }
        
        self.tableView.reloadData()
        indicator.stopAnimating()
    }
    
}
