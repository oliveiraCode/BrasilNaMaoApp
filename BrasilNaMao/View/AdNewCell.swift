//
//  AdNewCell.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class AdNewCell: UITableViewCell {
    
    @IBOutlet weak var imgAD: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfComplement: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfProvince: UITextField!
    @IBOutlet weak var tfPostalCode: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfWeb: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        btnCategory.layer.cornerRadius = 7
        btnCategory.layer.borderColor = UIColor.black.cgColor
        btnCategory.layer.borderWidth = 0.5
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
