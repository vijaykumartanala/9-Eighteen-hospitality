//
//  ChatTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 17/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var chatStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
