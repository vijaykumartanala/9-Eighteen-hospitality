//
//  DetailPopularItemsViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 17/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class DetailPopularItemsViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var itemNamw: UILabel!
    @IBOutlet weak var instructions: UITextView!
    @IBOutlet weak var detailpopular: UITableView!
    
    var popularItem = [popularItems]()
    var selectedItem : String!
    var cartInfo: [String: String] = [:]
    var cartData : CartData? = nil
    var message = ""
    var itemCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "POPULAR ITEMS"
        instructions.layer.cornerRadius = 6
        instructions.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        instructions.layer.borderWidth = 1
        detailpopular.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        itemNamw.text! = selectedItem!
    }
    
    @IBAction func addtoOrder(_ sender: Any) {
        NineEighteenApis.message = instructions.text!
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            if(CartData.getItemsCount() > 0){
                if(CartData.menusectionexits(goalID: "\(popularItem.first!.menuSectionId!)")){
                    let results = CartData.exits(goalID: "\(popularItem.first!.id!)")
                    if results == true {
                        showToast(message: "Item already exists in the cart")
                    }
                    else {
                        saveData()
                    }
                }
                else{
                    ItemAlert()
                }
            } else {
                let results = CartData.exits(goalID: "\(popularItem.first!.id!)")
                if results == true {
                    showToast(message: "Item already exists in the cart")
                }
                else {
                    saveData()
                }
            }
        } else {
            CoreDataStack.shared.deleteContext()
            NineEighteenSocketIOManager.sharedInstance.createLogin(vc: self, message: "Login/Create account to place or manage an order.")
        }
    }
    
    //MARK:- coredata
    private func saveData() {
        if instructions.text! == "   type message here..." {}
        else {
            message = instructions.text!
        }
        cartInfo = ["categoryName" : popularItem.first!.name! , "foodDesc" : popularItem.first!.foodDesc! , "imageUrl" : "", "itemId" : "\(popularItem.first!.id!)" , "itemNote" : message, "name" : popularItem.first!.name!, "price": "\(popularItem.first!.price!)","psteligible":"","tax" :   popularItem.first!.tax!,"quantity" : "\(NineEighteenApis.itemcount)","sectionId":"\(popularItem.first!.menuSectionId!)"]
        do {
            if let _ = cartData {
                cartData!.CartData(cart: cartInfo)
            } else {
                let context = CoreDataStack.shared.persistentContainer.viewContext
                if let entity = NSEntityDescription.entity(forEntityName: "CartData", in: context) {
                    let student = CartData(entity: entity, insertInto: context)
                    student.CartData(cart: cartInfo)
                }
            }
            NineEighteenApis.itemcount = 1
            NineEighteenApis.isShow = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func ItemAlert() {
        let alert = UIAlertController(title: "Items already in cart", message: "Your cart contains items from a different menu location.Would you like to reset your cart before browsing this menu location?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            CoreDataStack.shared.deleteContext()
            self.navigationController!.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController!.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            instructions.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (instructions.text == "   type message here...") {
            instructions.text = ""
        }
        instructions.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(instructions.text == "") {
            instructions.text = "   type message here..."
        }
        instructions.resignFirstResponder()
    }
    
}

extension DetailPopularItemsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        cell.popularItems = self
        cell.popData(pop: popularItem[indexPath.row])
        cell.itemName.text! = popularItem[indexPath.row].name
        cell.itemDetail.text! = popularItem[indexPath.row].foodDesc
        cell.price.text! = "$ " + "\(popularItem[indexPath.row].price!)"
        cell.itemCount.text! = "\(popularItem[indexPath.row].quantity!)"
        cell.addButton.tag =  Int(popularItem[indexPath.row].id!)
        cell.minusButton.tag = Int(popularItem[indexPath.row].id!)
        cell.isPopular = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
