//
//  HomePopularItemsTableViewCell.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 11/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HomePopularItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemView.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        itemView.layer.cornerRadius = 29
        itemView.layer.borderWidth = 2
        itemView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
