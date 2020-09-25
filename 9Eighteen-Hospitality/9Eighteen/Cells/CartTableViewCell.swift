//
//  CartTableViewCell.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 12/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartCardView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countStack: UIStackView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemDetail: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var detailItems : OrderSummaryViewController?
    var popularItems : DetailPopularItemsViewController?
    var cartItem : CartViewController?

    var feeds : CartData?
    var popular : popularItems?
    var cartDetails : CartData?
    
    var isPopular : Bool!
    var isCart : Bool!
    
    var someValue: Int = 1 {
        didSet {
            itemCount.text! = "\(someValue)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cartCardView.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        cartCardView.layer.cornerRadius = 6
        cartCardView.layer.borderWidth = 1
        cartCardView.clipsToBounds = true
        countView.layer.cornerRadius = 16
        countView.clipsToBounds = true
        countStack.layer.cornerRadius = 16
        countStack.clipsToBounds = true
        someValue = 1
        addButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    internal func updateInfo(feed:CartData) {
        feeds = feed
        someValue = Int(feeds!.quantity!)!
    }
    
    internal func popData(pop : popularItems) {
        popular = pop
    }
    
    internal func cartDetails(cartDetail : CartData) {
        cartDetails = cartDetail
        someValue = Int(cartDetails!.quantity!)!
    }
    
    
    @objc func add(sender : UIButton!) {
        if isPopular == true {
            someValue += 1
            itemCount.text! = "\(someValue)"
            NineEighteenApis.itemcount = someValue
            price.text! = "$ " + String(format: "%.2f",Double(popular!.price!) * Double(someValue))
        }
        else if isCart == true {
            someValue += 1
            itemCount.text! = "\(someValue)"
            price.text! = "$ " + String(format: "%.2f",Double(cartDetails!.price!)! * Double(someValue))
            CartData.fetchGoals(goalID: String(sender!.tag), quantity : itemCount.text!)
            cartItem?.cartTableViewController.reloadData()
        }
        else {
            someValue += 1
            itemCount.text! = "\(someValue)"
            CartData.fetchGoals(goalID: String(sender!.tag), quantity : itemCount.text!)
            detailItems?.orderTableview.reloadData()
            detailItems?.tax = 0.0
            detailItems?.totalPrice = 0.0
            detailItems?.calculations()
        }
    }
    
    @objc func minus(sender: UIButton!) {
        if isPopular == true {
            if itemCount.text! == "1" {
            }
            else {
                someValue -= 1
                itemCount.text! = "\(someValue)"
                NineEighteenApis.itemcount = someValue
                price.text! = "$ " + String(format: "%.2f",Double(popular!.price!) * Double(someValue))
            }
        }
        else if isCart == true {
            if itemCount.text! == "1" {
                CartData.deleteObj(goalID: String(sender!.tag))
                let buttonPostion = sender.convert(sender.bounds.origin, to: cartItem!.cartTableViewController)
                if let indexPath = cartItem!.cartTableViewController.indexPathForRow(at: buttonPostion) {
                    let index = indexPath.row
                    cartItem!.cartTableViewController!.beginUpdates()
                    cartItem!.cartDetails.remove(at: index)
                    self.cartItem!.cartTableViewController!.deleteRows(at: [indexPath], with: .automatic)
                    cartItem!.cartTableViewController!.endUpdates()
                }
                
            }
            else {
                someValue -= 1
                itemCount.text! = "\(someValue)"
                price.text! = "$ " + String(format: "%.2f",Double(cartDetails!.price!)! * Double(someValue))
                CartData.fetchGoals(goalID: String(sender!.tag), quantity : itemCount.text!)
                cartItem?.cartTableViewController.reloadData()
            }
        }
        else {
            if itemCount.text! == "1" {
                CartData.deleteObj(goalID: String(sender!.tag))
                let buttonPostion = sender.convert(sender.bounds.origin, to: detailItems!.orderTableview)
                if let indexPath = detailItems!.orderTableview.indexPathForRow(at: buttonPostion) {
                    let index = indexPath.row
                    detailItems!.orderTableview!.beginUpdates()
                    detailItems!.cartDetails.remove(at: index)
                    self.detailItems!.orderTableview!.deleteRows(at: [indexPath], with: .automatic)
                    detailItems!.orderTableview!.endUpdates()
                    detailItems?.tax = 0.0
                    detailItems?.totalPrice = 0.0
                    detailItems?.calculations()
                }
            }
            else {
                someValue -= 1
                itemCount.text! = "\(someValue)"
                CartData.fetchGoals(goalID: String(sender!.tag), quantity : itemCount.text!)
                detailItems?.orderTableview.reloadData()
                detailItems?.tax = 0.0
                detailItems?.totalPrice = 0.0
                detailItems?.calculations()
            }
        }
    }
}
