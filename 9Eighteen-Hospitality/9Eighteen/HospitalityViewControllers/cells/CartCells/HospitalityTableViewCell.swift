//
//  HospitalityTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 20/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityTableViewCell: UITableViewCell,toppingPrice {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countStack: UIStackView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cartCardView: UIView!
    @IBOutlet weak var toppingButton: UIButton!
    
    var cartDetails : HospitalityItems?
    var orderCartDetails : HospitalityItems?
    var cartItem : HospitalityCartViewController?
    var detailcartItem : HospitalityOrderSummaryViewController?
    var isCart : Bool!
    var toppingsPrice: Int = 0
    
    
    var someValue: Int = 0 {
        didSet {
            itemCount.text! = "\(someValue)"
        }
    }
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        cartCardView.layer.borderColor =  UIColor.init(hexString: "#3B88C3").cgColor
        cartCardView.layer.cornerRadius = 6
        cartCardView.layer.borderWidth = 1
        cartCardView.clipsToBounds = true
        countView.layer.cornerRadius = 16
        countView.clipsToBounds = true
        countStack.layer.cornerRadius = 16
        countStack.clipsToBounds = true
        addButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
        toppingButton.addTarget(self, action: #selector(self.topings), for: .touchUpInside)
    }
    
    internal func cartDetails(cartDetail : HospitalityItems) {
        cartDetails = cartDetail
        someValue = Int(cartDetails!.itemCount)
    }
    
    internal func updateInfoHospitality(feed:HospitalityItems) {
        orderCartDetails = feed
        someValue = Int(orderCartDetails!.itemCount)
    }
    
    @objc func add(sender : UIButton!) {
        if(isCart == true){
            someValue += 1
            itemCount.text! = "\(someValue)"
            itemPrice.text! = "$ " + String(format: "%.2f",Double(cartDetails!.price) * Double(someValue) + Double(toppingsPrice) * Double(someValue))
            HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : itemCount.text!)
            cartItem!.hospitalityTableview.reloadData()
        }else{
            someValue += 1
            itemCount.text! = "\(someValue)"
            itemPrice.text! = "$ " + String(format: "%.2f",Double(orderCartDetails!.price) * Double(someValue) +
            Double(toppingsPrice) * Double(someValue))
            HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : itemCount.text!)
            detailcartItem!.ordersummaryTableView.reloadData()
            detailcartItem?.tax = 0.0
            detailcartItem?.totalPrice = 0.0
            detailcartItem?.toppingsTax = 0.0
            detailcartItem?.toppingsPrice = 0.0
            detailcartItem?.calculations()
        }
        
    }
    
   //MARK:- Delegate Methods
 func dataUpdated(updated: Bool) {
    toppingsPrice = 0
    if updated == true {
        if(isCart == true){
            for i in cartDetails!.items!.allObjects as! [ItemsToppings] {
                if(i.is_selected == true){
                    toppingsPrice += Int(i.price)
                }
            }
            itemPrice.text! = "$ " + String(format: "%.2f",Double(cartDetails!.price) * Double(someValue) + Double(toppingsPrice))
            cartItem!.hospitalityTableview.reloadData()
        }else{
            for i in orderCartDetails!.items!.allObjects as! [ItemsToppings] {
                if(i.is_selected == true){
                    toppingsPrice += Int(i.price)
                }
            }
            itemPrice.text! = "$ " + String(format: "%.2f",Double(orderCartDetails!.price) * Double(someValue) +
            Double(toppingsPrice) * Double(someValue))
            detailcartItem!.ordersummaryTableView.reloadData()
            detailcartItem?.tax = 0.0
            detailcartItem?.totalPrice = 0.0
            detailcartItem?.toppingsTax = 0.0
            detailcartItem?.toppingsPrice = 0.0
            detailcartItem?.calculations()
        }
    }
}
    
    @objc func minus(sender: UIButton!) {
    if(isCart == true){
        if itemCount.text! == "1" {
            HospitalityCartData.deleteOrderObj(goalID: String(sender!.tag))
            let buttonPostion = sender.convert(sender.bounds.origin, to: cartItem!.hospitalityTableview)
            if let indexPath = cartItem!.hospitalityTableview.indexPathForRow(at: buttonPostion) {
                let index = indexPath.row
                cartItem!.hospitalityTableview!.beginUpdates()
                cartItem!.cartDetails.remove(at: index)
                self.cartItem!.hospitalityTableview!.deleteRows(at: [indexPath], with: .automatic)
                cartItem!.hospitalityTableview!.endUpdates()
            }
        }
        else {
            someValue -= 1
            itemCount.text! = "\(someValue)"
            itemPrice.text! = "$ " + String(format: "%.2f",Double(cartDetails!.price) * Double(someValue))
            HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : itemCount.text!)
            cartItem!.hospitalityTableview.reloadData()
            
        }
    }
    else{
        if itemCount.text! == "1" {
            HospitalityCartData.deleteOrderObj(goalID: String(sender!.tag))
            let buttonPostion = sender.convert(sender.bounds.origin, to: detailcartItem!.ordersummaryTableView)
            if let indexPath = detailcartItem!.ordersummaryTableView.indexPathForRow(at: buttonPostion) {
                let index = indexPath.row
                detailcartItem!.ordersummaryTableView!.beginUpdates()
                detailcartItem!.cartDetails.remove(at: index)
                self.detailcartItem!.ordersummaryTableView!.deleteRows(at: [indexPath], with: .automatic)
                detailcartItem!.ordersummaryTableView!.endUpdates()
                detailcartItem?.tax = 0.0
                detailcartItem?.totalPrice = 0.0
                detailcartItem?.toppingsTax = 0.0
                detailcartItem?.toppingsPrice = 0.0
                detailcartItem?.calculations()
            }
        }
        else {
            someValue -= 1
            itemCount.text! = "\(someValue)"
            itemPrice.text! = "$ " + String(format: "%.2f",Double(orderCartDetails!.price) * Double(someValue))
            HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : itemCount.text!)
            detailcartItem!.ordersummaryTableView.reloadData()
            detailcartItem?.tax = 0.0
            detailcartItem?.totalPrice = 0.0
            detailcartItem?.toppingsTax = 0.0
            detailcartItem?.toppingsPrice = 0.0
            detailcartItem?.calculations()
        }
    }
}
    
    @objc func topings(sender : UIButton!) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "CartPopupViewController") as!  CartPopupViewController
        newViewcontroller.selectedId = sender.tag
        newViewcontroller.delegate = self
        newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
            if(self.isCart == true){
                newViewcontroller.itemPrice = Int(self.cartDetails!.price)
                self.cartItem!.present(newViewcontroller, animated: true, completion:nil)
            }else{
                newViewcontroller.itemPrice = Int(self.orderCartDetails!.price)
                self.detailcartItem!.present(newViewcontroller, animated: true, completion:nil)
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
