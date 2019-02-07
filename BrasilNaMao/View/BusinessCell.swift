//
//  BusinessCell.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-30.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos

class BusinessCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgLogo.layer.cornerRadius = 15
        self.imgLogo.clipsToBounds = true

        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
