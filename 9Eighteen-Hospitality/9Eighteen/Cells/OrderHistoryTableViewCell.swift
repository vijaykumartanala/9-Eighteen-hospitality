//
//  OrderHistoryTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 16/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
