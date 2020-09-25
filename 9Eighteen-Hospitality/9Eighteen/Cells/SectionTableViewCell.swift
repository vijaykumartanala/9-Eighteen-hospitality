//
//  SectionTableViewCell.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 12/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCardView: UIView!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemCardView.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        itemCardView.layer.cornerRadius = 25
        itemCardView.layer.borderWidth = 1
        itemCardView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
