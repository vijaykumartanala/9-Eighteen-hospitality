//
//  PopupViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 20/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class PopupViewController: UIViewController {
    
    @IBOutlet var popupview: UIView!
    @IBOutlet weak var popupTableview: UITableView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var price: UILabel!
    
    var toppings = [itemToppings]()
    var itemArray = [items]()
    var cartDetails : HospitalityCartData?
    var cartInfo: [String: String] = [:]
    var cartData : HospitalityCartData? = nil
    var arrSelectedRows = [Int]()
    let checkedImage = UIImage(named: "checkbox")! as UIImage
    let uncheckedImage = UIImage(named: "check-box-empty")! as UIImage
    var top_price = [Int]()
    var bussiness_id : Int!
    var delivery_type : String!
    var headerTitle: String?
    var image_url : String?
    var tip1 : Double?
    var tip2 : Double?
    var tip3 : Double?
    var exploreItems : ExploreDetailViewController?
    
    var someValue: Int = 0 {
           didSet {
             price.text! = "Item Price  " + "\(someValue)"
           }
       }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        popupTableview.register(UINib(nibName: "PopupTableViewCell", bundle: nil), forCellReuseIdentifier: "PopupTableViewCell")
        popupTableview.reloadData()
        popupTableview.tableFooterView = UIView()
        popupTableview.allowsMultipleSelection = true
        someValue = itemArray.first!.price
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        })
    }
    
    @IBAction func done(_ sender: Any) {
        saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
       saveData()
      self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- coredata
    private func saveData() {
        let itemDetails = HospitalityItems(context: CoreDataStack.shared.persistentContainer.viewContext)
        itemDetails.has_toppings = true
        itemDetails.bussiness_name = headerTitle!
        itemDetails.bussiness_imageurl = image_url
        itemDetails.bussiness_id = Int16(bussiness_id!)
        itemDetails.delivery_type = Int16(delivery_type!)!
        itemDetails.category_id = Int16(itemArray.first!.category_id!)
        itemDetails.id = Int16(itemArray.first!.id!)
        itemDetails.item_description = itemArray.first!.description!
        itemDetails.itemCount = Int16(itemArray.first!.itemCount!)
        itemDetails.name = itemArray.first!.name!
        itemDetails.price = Int16(itemArray.first!.price!)
        itemDetails.tax = itemArray.first!.tax
        itemDetails.tip1 = tip1!
        itemDetails.tip2 = tip2!
        itemDetails.tip3 = tip3!
        CoreDataStack.shared.saveContext()
        for i in toppings {
                let selectedtoppings = ItemsToppings(context: CoreDataStack.shared.persistentContainer.viewContext)
                selectedtoppings.id = Int16(i.id!)
                selectedtoppings.item_id = Int16(i.item_id!)
                selectedtoppings.price = Int16(i.price!)
                selectedtoppings.name = i.name!
                selectedtoppings.is_selected = i.isSelected!
                selectedtoppings.topping_tax = i.topping_tax!
                itemDetails.addToItems(selectedtoppings)
                CoreDataStack.shared.saveContext()
        }
        
    }
    
}

extension PopupViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupTableViewCell") as! PopupTableViewCell
        let prices = "$ " + String(format: "%.2f" ,(Double(toppings[indexPath.row].price!)))
        if(self.arrSelectedRows.contains(toppings[indexPath.row].id)){
            cell.itemButton.setImage(checkedImage, for: .normal)
            toppings[indexPath.row].isSelected = true
         }
        else {
            toppings[indexPath.row].isSelected = false
            cell.itemButton.setImage(uncheckedImage , for: .normal)
        }
        if(top_price.count > 0){
           someValue = itemArray.first!.price + top_price.reduce(0, +)
        }else{
           someValue = itemArray.first!.price
        }
        cell.toppingItems = self
        cell.toppingsData(item: toppings[indexPath.row])
        cell.itemButton.tag = toppings[indexPath.row].id
        cell.itemName.text! = toppings[indexPath.row].name + "      " + prices
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

