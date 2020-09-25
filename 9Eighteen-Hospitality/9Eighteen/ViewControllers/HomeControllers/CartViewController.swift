//
//  CartViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 11/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var cartTableViewController: UITableView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet var bgView: UIView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var cartDetails = [CartData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CART"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        cartTableViewController.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        message.layer.cornerRadius = 6
        message.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        message.layer.borderWidth = 1
        appdelegate.notificationcenter.addObserver(self, selector: #selector(showCounter), name: Notification.Name("recivedPushN"), object: nil)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.count), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCounter()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        self.cartDetails = CartData.fetchCartDetails()
        message.text! = NineEighteenApis.message
        self.cartTableViewController.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NineEighteenApis.isShow = false
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    @objc private func fetchNewMessages(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let newList = userInfo["newChat"] as! [[String:Any]]
            for i in newList {
                createAlert(order: i["order_id"] as? String, driverId: i["driver_id"] as? String)
            }
        }
    }
    
    private func createAlert(order:String!,driverId:String!) {
        let alert = UIAlertController(title: "9-Eighteen", message: "You have a new message regarding a 9-Eighteen order", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "View", style: UIAlertAction.Style.default, handler: { (action) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            studentDVC.order = order
            studentDVC.driverId = driverId
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func count() {
        getItemsCount()
    }
    
    private func getItemsCount() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            if(CartData.getItemsCount() == 0){
                tabItem.badgeValue = nil
            }else{
                tabItem.badgeValue = String(CartData.getItemsCount())
            }
        }
    }

    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: false)
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        navigationController?.pushViewController(studentDVC, animated: true)
        
    }
    
    @IBAction func orderNow(_ sender: Any) {
        NineEighteenApis.message = message.text!
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        studentDVC.cartDetails = cartDetails
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    //MARK:- TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            message.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (message.text == "   type message here...") {
            message.text = ""
        }
        message.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(message.text == "") {
            message.text = "   type message here..."
        }
        message.resignFirstResponder()
    }
}

extension CartViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartTableViewController.tableFooterView!.isHidden = false
        cartTableViewController.tableHeaderView!.isHidden = false
        if cartDetails.count == 0 {
            cartTableViewController.backgroundView = bgView
            cartTableViewController.tableFooterView!.isHidden = true
            cartTableViewController.tableHeaderView!.isHidden = true
        }
        else {
            cartTableViewController.backgroundView = nil
            cartTableViewController.tableFooterView!.isHidden = false
            cartTableViewController.tableHeaderView!.isHidden = false
        }
        return cartDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        cell.cartItem = self
        cell.cartDetails(cartDetail: cartDetails[indexPath.row])
        cell.itemName.text! = cartDetails[indexPath.row].name!
        cell.itemDetail.text! = cartDetails[indexPath.row].foodDesc!
        cell.itemCount.text! = cartDetails[indexPath.row].quantity!
        cell.price.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price!)! * Double(cartDetails[indexPath.row].quantity!)!))
        cell.addButton.tag =  Int(cartDetails[indexPath.row].itemId!)!
        cell.minusButton.tag = Int(cartDetails[indexPath.row].itemId!)!
        cell.isCart = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
