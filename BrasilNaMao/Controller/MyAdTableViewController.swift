//
//  MyAdTableViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit



class MyAdTableViewController: UITableViewController  {
    
    var categoryValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "AdNewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AdNewCell")

        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdNewCell", for: indexPath) as! AdNewCell
        
        if categoryValue == nil {
            cell.btnCategory.setTitle("Select", for: .normal)
        } else {
            cell.btnCategory.setTitle(self.categoryValue, for: .normal)
        }
        
        cell.btnCategory.tag = indexPath.row
        cell.btnCategory.addTarget(self, action: #selector(self.btnCategory(_:)), for: .touchUpInside);
        
        return cell
    }
    
    @objc func btnCategory(_ sender : UIButton){
        performSegue(withIdentifier: "showCategoryVC", sender: nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navController = segue.destination as! UINavigationController
        let destController = navController.topViewController as! CategoryTableViewController
        destController.delegate = self
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MyAdTableViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        self.categoryValue = categoryValue
        self.tableView.reloadData()
    }
    
}
