//
//  SubSectionTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 30/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class SubSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemCardView: UIView!
    @IBOutlet weak var childcard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemCardView.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        itemCardView.layer.cornerRadius = 6
        itemCardView.layer.borderWidth = 1
        itemCardView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
