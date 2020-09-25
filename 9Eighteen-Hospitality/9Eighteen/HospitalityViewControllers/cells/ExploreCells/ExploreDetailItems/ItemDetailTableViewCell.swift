//
//  ItemDetailTableViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 19/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var cartCardView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countStack: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addButton: NineEighteenButton!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var someValue: Int = 1 {
        didSet {
            itemCount.text! = "\(someValue)"
        }
    }
    
    var exploreItems : ExploreDetailViewController?
    var isExplore : Bool?
    var explore : items?
    var cartInfo: [String: String] = [:]
    var cartData : HospitalityItems? = nil
    var bussiness_id : Int!
    var delivery_type : String!
    var cartDetails = [HospitalityItems]()
    var headerTitle: String?
    var image_url : String?
    var tip1 : Double?
    var tip2 : Double?
    var tip3 : Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cartCardView.layer.borderColor = UIColor.init(hexString: "#3B88C3").cgColor
        cartCardView.layer.cornerRadius = 6
        cartCardView.layer.borderWidth = 1
        cartCardView.clipsToBounds = true
        countView.layer.cornerRadius = 16
        countView.clipsToBounds = true
        addView.layer.cornerRadius = 16
        addView.clipsToBounds = true
        countStack.layer.cornerRadius = 16
        countStack.clipsToBounds = true
        someValue = 1
        plusButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.intialAdd), for: .touchUpInside)
    }
    
    
    @objc func intialAdd(sender : UIButton!) {
        if(isExplore == true){
            self.cartDetails = HospitalityCartData.fetchItemDetails()
            if(self.cartDetails.count > 0){
                if(HospitalityCartData.bussinessItemsIDExits(goalID: "\(bussiness_id!)")){
                    if exploreItems!.arrSelectedRows.contains(sender.tag){
                        exploreItems!.arrSelectedRows.remove(at: exploreItems!.arrSelectedRows.index(of: sender.tag)!)
                    } else {
                        exploreItems!.arrSelectedRows.append(sender.tag)
                    }
                    if(explore!.has_toppings){
                        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
                        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "PopupViewController") as!  PopupViewController
                        let buttonPostion = sender.convert(sender.bounds.origin, to: exploreItems!.itemDetails)
                        if let indexPath = exploreItems!.itemDetails.indexPathForRow(at: buttonPostion) {
                            newViewcontroller.toppings = exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].tbl_item_toppings
                            newViewcontroller.itemArray = [exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row]]
                            newViewcontroller.bussiness_id = bussiness_id!
                            newViewcontroller.delivery_type = delivery_type!
                            newViewcontroller.headerTitle = headerTitle!
                            newViewcontroller.delivery_type = delivery_type!
                            newViewcontroller.image_url = image_url!
                            newViewcontroller.tip1 = tip1
                            newViewcontroller.tip2 = tip2
                            newViewcontroller.tip3 = tip3
                        }
                        newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
                            self.exploreItems!.present(newViewcontroller, animated: true, completion:nil)
                        })
                    } else {
                        saveData()
                    }
                    exploreItems!.itemDetails.reloadData()
                } else {
                  createAlert()
                }
            } else {
                if exploreItems!.arrSelectedRows.contains(sender.tag){
                    exploreItems!.arrSelectedRows.remove(at: exploreItems!.arrSelectedRows.index(of: sender.tag)!)
                } else {
                    exploreItems!.arrSelectedRows.append(sender.tag)
                }
                if(explore!.has_toppings){
                    let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
                    let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "PopupViewController") as!  PopupViewController
                    let buttonPostion = sender.convert(sender.bounds.origin, to: exploreItems!.itemDetails)
                    if let indexPath = exploreItems!.itemDetails.indexPathForRow(at: buttonPostion) {
                        newViewcontroller.toppings = exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].tbl_item_toppings
                        newViewcontroller.itemArray = [exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row]]
                        newViewcontroller.bussiness_id = bussiness_id!
                        newViewcontroller.delivery_type = delivery_type!
                        newViewcontroller.headerTitle = headerTitle!
                        newViewcontroller.delivery_type = delivery_type!
                         newViewcontroller.image_url = image_url!
                        newViewcontroller.tip1 = tip1
                        newViewcontroller.tip2 = tip2
                        newViewcontroller.tip3 = tip3
                    }
                    newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
                        self.exploreItems!.present(newViewcontroller, animated: true, completion:nil)
                    })
                } else {
                    saveData()
                }
                exploreItems!.itemDetails.reloadData()
            }
        }
    }
    
    @objc func add(sender : UIButton!) {
        if(isExplore == true){
            let buttonPostion = sender.convert(sender.bounds.origin, to: exploreItems!.itemDetails)
            if let indexPath = exploreItems!.itemDetails.indexPathForRow(at: buttonPostion) {
                exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount += 1
                HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : "\(exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!)")
                exploreItems!.itemDetails.reloadData()
            }
        }
    }
    
    @objc func minus(sender: UIButton!) {
        if(isExplore == true){
            if(itemCount.text! == "1"){
                HospitalityCartData.deleteOrderObj(goalID: String(sender!.tag))
                if exploreItems!.arrSelectedRows.contains(sender.tag){
                    exploreItems!.arrSelectedRows.remove(at: exploreItems!.arrSelectedRows.index(of: sender.tag)!)
                    exploreItems!.itemDetails.reloadData()
                }
            } else {
                let buttonPostion = sender.convert(sender.bounds.origin, to: exploreItems!.itemDetails)
                if let indexPath = exploreItems!.itemDetails.indexPathForRow(at: buttonPostion) {
                    exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount -= 1
                    HospitalityCartData.fetchOrderedItems(goalID: String(sender!.tag), quantity : "\(exploreItems!.bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!)")
                    exploreItems!.itemDetails.reloadData()
                }
            }
        }
    }
    
    //MARK:- coredata
       private func saveData() {
           let itemDetails = HospitalityItems(context: CoreDataStack.shared.persistentContainer.viewContext)
           itemDetails.has_toppings = false
           itemDetails.bussiness_name = headerTitle!
           itemDetails.bussiness_imageurl = image_url!
           itemDetails.bussiness_id = Int16(bussiness_id!)
           itemDetails.delivery_type = Int16(delivery_type!)!
           itemDetails.category_id = Int16(explore!.category_id!)
           itemDetails.id = Int16(explore!.id!)
           itemDetails.item_description = explore!.description!
           itemDetails.itemCount = Int16(explore!.itemCount!)
           itemDetails.name = explore!.name!
           itemDetails.price = Int16(explore!.price!)
           itemDetails.tax = explore!.tax
           CoreDataStack.shared.saveContext()
           
           
       }
       
    internal func exploreData(item : items) {
        explore = item
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func createAlert() {
        let alert = UIAlertController(title: "Items already in cart", message: "Your cart contains items from a different restaurant.Would you like to reset your cart before browsing this restaurant?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            CoreDataStack.shared.deleteOrderedItems()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.exploreItems!.navigationController!.popViewController(animated: true)
        }))
        exploreItems!.present(alert, animated: true, completion: nil)
    }
}
