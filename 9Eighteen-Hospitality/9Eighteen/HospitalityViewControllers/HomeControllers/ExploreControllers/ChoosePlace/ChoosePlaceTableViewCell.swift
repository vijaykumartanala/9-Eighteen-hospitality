//
//  ChoosePlaceTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 18/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class ChoosePlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var ChooseImage: UIImageView!
    @IBOutlet weak var ChooseName: UILabel!
    @IBOutlet weak var Choose: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Choose.layer.borderColor = UIColor.init(hexString: "#3B88C3").cgColor
        Choose.layer.borderWidth = 1
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
