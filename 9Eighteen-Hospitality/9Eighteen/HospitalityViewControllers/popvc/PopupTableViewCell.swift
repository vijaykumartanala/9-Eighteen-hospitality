//
//  PopupTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 20/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class PopupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    
    var toppingItems : PopupViewController?
    var toppings :  itemToppings?
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        itemButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func add(sender : UIButton!) {
        if toppingItems!.arrSelectedRows.contains(sender.tag){
           toppingItems!.arrSelectedRows.remove(at: toppingItems!.arrSelectedRows.index(of: sender.tag)!)
            if((toppingItems?.top_price.count)! > 0){
                toppingItems?.top_price.remove(object: (toppings?.price!)!)
            }
        } else {
            toppingItems!.arrSelectedRows.append(sender.tag)
            toppingItems?.top_price.append(toppings!.price)
        }
        toppingItems!.popupTableview.reloadData()
    }
    
    internal func toppingsData(item : itemToppings) {
        toppings = item
    }
    
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
