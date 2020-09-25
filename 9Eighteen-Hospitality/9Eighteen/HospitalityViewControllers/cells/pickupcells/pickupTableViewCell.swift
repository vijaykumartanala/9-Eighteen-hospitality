//
//  pickupTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 25/07/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class pickupTableViewCell: UITableViewCell {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var pickupCardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       pickupCardView.layer.borderColor = UIColor.darkGray.cgColor
       pickupCardView.layer.cornerRadius = 6
       pickupCardView.layer.borderWidth = 1
       pickupCardView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
