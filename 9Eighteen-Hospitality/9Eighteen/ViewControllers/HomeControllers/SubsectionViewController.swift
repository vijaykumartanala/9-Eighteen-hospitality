//
//  SubsectionViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 12/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class SubsectionViewController: UIViewController {
    
    @IBOutlet weak var subSectionTableview: UITableView!
    @IBOutlet weak var subType: UILabel!
    @IBOutlet weak var orderButton: NineEighteenButton!
    
    var id : Int!
    var menu_id : Int!
    var subSec = [subSectionData]()
    var subName : String!
    var subSectionInfo = [[String: String]]()
    var cartData : CartData? = nil
    var cartDetails = [CartData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMethod()
        showCounter()
        allItemsApi()
        subType.text! = subName!
        subSectionTableview.allowsMultipleSelection = true
        orderButton.isHidden = false
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showCounter), userInfo: nil, repeats: true)
    }
    
    @objc func showCounter(){
        self.addBadge(itemvalue:String(CartData.getItemsCount()), isCart: true, isHospitality: false)
    }
    
    @IBAction func addCart(_ sender: Any) {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            if(CartData.getItemsCount() > 0){
                if(CartData.menusectionexits(goalID: String(menu_id))){
                    sampleData()
                    if subSectionInfo.count > 0 {
                        saveData()
                    }
                }else{
                    ItemAlert()
                }
            }else{
                sampleData()
                if subSectionInfo.count > 0 {
                    saveData()
                }
            }
        } else {
            CoreDataStack.shared.deleteContext()
            NineEighteenSocketIOManager.sharedInstance.createLogin(vc: self, message: "Login/Create account to place or manage an order.")
        }
    }
    
    func sampleData(){
        for i in subSec {
            if let id = i.id {
                let results = CartData.exits(goalID: "\(id)")
                if results == true && i.isSelected == true {
                    CartData.updateData(goalID: "\(id)", quantity: 1)
                    createAlert()
                }
                else if i.isSelected == true {
                    subSectionInfo.append([
                        "categoryName" : i.foodDesc! ,
                        "foodDesc" : i.foodDesc! ,
                        "imageUrl" : "",
                        "itemId" : "\(i.id!)",
                        "itemNote" : "",
                        "name" : i.name!,
                        "price": "\(i.price!)",
                        "psteligible":"",
                        "quantity" : "1" ,
                        "tax" : i.tax!,
                        "sectionId":String(menu_id!)
                    ])
                }
                else {}
            }
        }
    }
    
    //MARK:- CoreData
    private func saveData() {
        do {
            if let _ = cartData {
                for i in subSectionInfo {
                    cartData!.CartData(cart: i)
                }
                
            } else {
                for i in subSectionInfo {
                    let context = CoreDataStack.shared.persistentContainer.viewContext
                    if let entity = NSEntityDescription.entity(forEntityName: "CartData", in: context) {
                        let student = CartData(entity: entity, insertInto: context)
                        student.CartData(cart: i)
                    }
                }
                subSectionInfo.removeAll()
                createAlert()
            }
        }
    }
    
    //MARK:- Custom Methods
    private func customMethod() {
        self.navigationItem.title = "MENU"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        subSectionTableview.register(UINib(nibName: "SubSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SubSectionTableViewCell")
    }
    
    //MARK:- Api Calling
    private func allItemsApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["categoryId": "\(id!)" , "courseId" :dataTask.LoginData().courseId!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.getAllItemsApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    print(json)
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        let results = json["results"] as? [[String:Any]]
                        if results?.count == 0 {
                            self.orderButton.isHidden = true
                        }
                        else {self.orderButton.isHidden = false}
                        for i in results! {
                            self.subSec.append(subSectionData(data: i))
                        }
                    }
                    else {
                        self.orderButton.isHidden = true
                        guard let message = json["message"] as? String else {return}
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "\(message)", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.subSectionTableview.reloadData()
                }
            }
        }
    }
    
    func createAlert() {
        let alert = UIAlertController(title: "Are You Sure?", message: "Continue Ordering or Checkout", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { (action) in
            NineEighteenApis.isShow = true
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Checkout", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            let  _ = self.tabBarController?.viewControllers![1] as! UINavigationController
            self.tabBarController?.selectedIndex = 1
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ItemAlert(){
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
}

extension SubsectionViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSectionTableViewCell") as! SubSectionTableViewCell
        if subSec[indexPath.row].isSelected == true {
            cell.itemCardView.backgroundColor = UIColor(red: 12/255, green: 110/255, blue: 76/255, alpha: 1)
            cell.itemName.text! = subSec[indexPath.row].name
            cell.itemPrice.text! = "$ " + "\(String(describing: subSec[indexPath.row].price!))"
            cell.itemDesc.text! = subSec[indexPath.row].foodDesc
            cell.itemName.textColor! = UIColor.white
            cell.itemPrice.textColor! = UIColor.white
            cell.itemDesc.textColor! = UIColor.white
        }
        else {
            cell.itemName.text! = subSec[indexPath.row].name
            cell.itemName.textColor! = UIColor.black
            cell.itemPrice.textColor! = UIColor.black
            cell.itemDesc.textColor! = UIColor.black
            cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(subSec[indexPath.row].price!)))
            cell.itemDesc.text! = subSec[indexPath.row].foodDesc
            cell.itemCardView.backgroundColor = UIColor(red: 238/255, green: 239/255, blue: 238/255, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = subSectionTableview.cellForRow(at: indexPath) as! SubSectionTableViewCell
        if subSec[indexPath.row].isSelected == true {
            subSec[indexPath.row].isSelected = false
            cell.itemCardView.backgroundColor = UIColor(red: 238/255, green: 239/255, blue: 238/255, alpha: 1)
            cell.itemName.textColor! = UIColor.black
            cell.itemPrice.textColor! = UIColor.black
            cell.itemDesc.textColor! = UIColor.black
        }
        else {
            subSec[indexPath.row].isSelected = true
            cell.itemName.textColor! = UIColor.white
            cell.itemPrice.textColor! = UIColor.white
            cell.itemDesc.textColor! = UIColor.white
            cell.itemCardView.backgroundColor = UIColor(red: 12/255, green: 110/255, blue: 76/255, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = subSectionTableview.cellForRow(at: indexPath) as! SubSectionTableViewCell
        subSec[indexPath.row].isSelected = false
        cell.itemCardView.backgroundColor = UIColor(red: 238/255, green: 239/255, blue: 238/255, alpha: 1)
        cell.itemName.textColor! = UIColor.black
        cell.itemPrice.textColor! = UIColor.black
        cell.itemDesc.textColor! = UIColor.black
    }
}
