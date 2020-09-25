//
//  HospitalityCartViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class HospitalityCartViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var hospitalityTableview: UITableView!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var cartName: UILabel!
    
    var cartDetails = [HospitalityItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalityTableview.register(UINib(nibName: "HospitalityTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalityTableViewCell")
        message.layer.cornerRadius = 6
        message.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 97/255, alpha: 1.0).cgColor
        message.layer.borderWidth = 1
        self.cartImage.layer.cornerRadius = 16.0
        self.cartImage.layer.masksToBounds = true
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        showCounter()
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: true)
    }
    
    @objc func getItemsCount() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            if(HospitalityCartData.getToppingsCount() == 0){
                tabItem.badgeValue = nil
            }else{
                tabItem.badgeValue = String(HospitalityCartData.getToppingsCount())
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getItemsCount), userInfo: nil, repeats: true)
        self.cartDetails = HospitalityCartData.fetchItemDetails()
        if(self.cartDetails.count > 0){
            cartName.text! = self.cartDetails.first?.bussiness_name! ?? ""
            cartImage.sd_setImage(with: URL(string: self.cartDetails.first!.bussiness_imageurl ?? ""), placeholderImage: UIImage(named: "resort"))
        }
        self.hospitalityTableview.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        let alert = UIAlertController(title: "Hospitality", message: "You have a new message regarding a Hospitality order", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "View", style: UIAlertAction.Style.default, handler: { (action) in
            let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityChatViewController") as! HospitalityChatViewController
            studentDVC.order = order
            studentDVC.driverId = driverId
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    
    @IBAction func orderNow(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityOrderSummaryViewController") as! HospitalityOrderSummaryViewController
        studentDVC.cartDetails = cartDetails
        NineEighteenApis.message = message.text!
        navigationController?.pushViewController(studentDVC, animated: true)
    }
}

extension HospitalityCartViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hospitalityTableview.tableFooterView!.isHidden = false
        hospitalityTableview.tableHeaderView!.isHidden = false
        if cartDetails.count == 0 {
            hospitalityTableview.backgroundView = bgView
            hospitalityTableview.tableFooterView!.isHidden = true
            hospitalityTableview.tableHeaderView!.isHidden = true
        }
        else {
            hospitalityTableview.backgroundView = nil
            hospitalityTableview.tableFooterView!.isHidden = false
            hospitalityTableview.tableHeaderView!.isHidden = false
        }
        return cartDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalityTableViewCell") as! HospitalityTableViewCell
        cell.cartItem = self
        cell.contentView.backgroundColor = UIColor.white
        cell.cartCardView.backgroundColor = .white
        cell.cartDetails(cartDetail: cartDetails[indexPath.row])
        cell.itemName.text! = cartDetails[indexPath.row].name!
        cell.itemDesc.text! = cartDetails[indexPath.row].item_description!
        cell.itemCount.text! = String(cartDetails[indexPath.row].itemCount)
        if((cartDetails[indexPath.row].items?.allObjects.count)! > 0){
            var totalPrice = 0
            for i in cartDetails[indexPath.row].items!.allObjects as! [ItemsToppings] {
                if(i.is_selected == true){
                    totalPrice += Int(i.price)
                }
            }
            cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price) * Double(cartDetails[indexPath.row].itemCount)) + Double(totalPrice) * Double(cartDetails[indexPath.row].itemCount))
            cell.toppingButton.tag = Int(cartDetails[indexPath.row].id)
        }
        else{
            cell.toppingButton.isHidden = true
            cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price) * Double(cartDetails[indexPath.row].itemCount)))
        }
        cell.addButton.tag =  Int(cartDetails[indexPath.row].id)
        cell.minusButton.tag = Int(cartDetails[indexPath.row].id)
        cell.isCart = true
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

