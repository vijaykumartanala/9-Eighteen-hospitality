//
//  OrderHistoryDetailTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 16/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class OrderHistoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
