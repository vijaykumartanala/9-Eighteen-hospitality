//
//  HospitalityOrderHistoryTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 05/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityOrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var toppingsButton: UIButton!
    var orderItem = [orderToppings]()
    var history : HospitalityHistoryDetailViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       toppingsButton.addTarget(self, action: #selector(self.topings), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func toppingsDetails(toppingDetail : [[String:Any]]) {
        for i in toppingDetail {
            orderItem.append(orderToppings(data: i))
        }
    }
    
    @objc func topings(sender : UIButton!) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "CartPopupViewController") as!  CartPopupViewController
         newViewcontroller.toppingData = orderItem
         newViewcontroller.fromHistory = true
         newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
           self.history!.present(newViewcontroller, animated: true, completion:nil)
        })
    }
}
