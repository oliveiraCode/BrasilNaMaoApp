//
//  CategoryTableViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-08.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Firebase

class CategoryTableViewController: UITableViewController {
    
    var delegate: CategoryDelegate?
    var categories = [Category]()
    var indexPathSelected:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRFirestoreService.shared.readCategory { (category, error) in
            self.categories = category as! [Category]
            self.tableView.reloadData()
        }

    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        
        if (indexPathSelected != nil && indexPathSelected == indexPath.row){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = self.categories[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelected = indexPath.row
        tableView.reloadData()
    }
    
    
    @IBAction func btnSavePressed(_ sender: Any) {
        self.delegate?.categoryValueSelected(categoryValue: self.categories[indexPathSelected].name)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
