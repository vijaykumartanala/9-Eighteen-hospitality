//
//  CartPopupViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 19/07/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

protocol toppingPrice {
    func dataUpdated(updated : Bool)
}

class CartPopupViewController: UIViewController {

     var carttoppings = [ItemsToppings]()
     let checkedImage = UIImage(named: "checkbox")! as UIImage
     let uncheckedImage = UIImage(named: "check-box-empty")! as UIImage
     var arrSelectedRows = [Int]()
     var selectedId : Int?
     var delegate : toppingPrice!
     var toppingData = [orderToppings]()
     var fromHistory : Bool!
     var top_price = [Int]()
     var itemPrice : Int = 0
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var cartpopupTableView: UITableView!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var price: UILabel!
    
    var someValue: Int = 0 {
        didSet {
          price.text! = "Item Price  " + "\(someValue)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (fromHistory == true) {
            footer.isHidden = true
            heading.text! = "Selected Toppings"
        }else{
          heading.text! = "Select your Toppings"
          someValue = itemPrice
          self.carttoppings = HospitalityCartData.fetchToppingDetails(item_id: Int16(selectedId!))
        }
       cartpopupTableView.register(UINib(nibName: "CartPopupTableViewCell", bundle: nil), forCellReuseIdentifier: "CartPopupTableViewCell")
       cartpopupTableView.reloadData()
       cartpopupTableView.tableFooterView = UIView()
       cartpopupTableView.allowsMultipleSelection = true
      UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseInOut, animations: {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      })
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if(fromHistory == true){}
        else{
          self.delegate.dataUpdated(updated: true)
        }
      self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemButton(_ sender: Any) {
        if(fromHistory == true){}
          else{
            self.delegate.dataUpdated(updated: true)
          }
        self.dismiss(animated: true, completion: nil)
    }
}

extension CartPopupViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(fromHistory == true){
            return toppingData.count
        }else{
          return carttoppings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartPopupTableViewCell") as! CartPopupTableViewCell
        if(fromHistory==true){
            let price = "$ " + String(format: "%.2f" ,(Double(toppingData[indexPath.row].price)))
            cell.itemName.text! = toppingData[indexPath.row].toppingName + "      " + price
            cell.itemButton.setImage(checkedImage, for: .normal)
            cell.itemButton.isUserInteractionEnabled = false
        }
        else{
            let price = "$ " + String(format: "%.2f" ,(Double(carttoppings[indexPath.row].price)))
            if(carttoppings[indexPath.row].is_selected){
              cell.itemButton.setImage(checkedImage, for: .normal)
            }
            else {
              cell.itemButton.setImage(uncheckedImage , for: .normal)
            }
            if(carttoppings.count > 0){
                var totalPrice = 0
                for i in carttoppings{
                    if(i.is_selected == true){
                        totalPrice += Int(i.price)
                    }
                }
                someValue = totalPrice + itemPrice
            }
            cell.cartToppingItems = self
            cell.itemButton.tag = Int(carttoppings[indexPath.row].id)
            cell.itemName.text! = carttoppings[indexPath.row].name! + "      " + price
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
