//
//  CartPopupTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 19/07/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class CartPopupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    
    var cartToppingItems : CartPopupViewController?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemButton.addTarget(self, action: #selector(self.topping), for: .touchUpInside)
    }

    @objc func topping(sender : UIButton!) {
         HospitalityCartData.changeToppingsStatus(id: Int16(sender!.tag))
         cartToppingItems!.cartpopupTableView.reloadData()
     }
       
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
