//
//  OrderHistoryDetailViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 16/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class OrderHistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var orderHistoryDetail: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var itemNote: UITextView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var cancelButton: NineEighteenButton!
    @IBOutlet weak var chatButton: NineEighteenButton!
    @IBOutlet weak var address: NSLayoutConstraint!
    @IBOutlet weak var footerViewHeight: NSLayoutConstraint!
   
    
    var order = [orderData]()
    var orderDetail = [orderDetailsData]()
    var isCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderHistoryDetail.register(UINib(nibName: "OrderHistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryDetailTableViewCell")
        self.navigationItem.title = "Order Detail"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        footerView.isHidden = false
        cancelButton.isHidden = true
        chatButton.isHidden = false
        itemNote.layer.cornerRadius = 6
        itemNote.layer.borderColor = UIColor.darkGray.cgColor
        itemNote.layer.borderWidth = 1
        if order.first?.status == "Reserved" {
            footerView.isHidden = false
            footerViewHeight.constant = 50
        }
        else if order.first?.status == "Pending" {
            cancelButton.isHidden = false
            chatButton.isHidden = true
            footerViewHeight.constant = 50
        }
        else {footerView.isHidden = true}
          orderDetails()
    }
    
    
    private func orderDetails() {
        FSActivityIndicatorView.shared.show()
        itemCount.text! = "Order Id: " + "\(String(describing: order.first!.databaseId!))"
        userName.text! = "\(order.first!.count!)" + " Item(s)"
        status.text! = order.first!.status!
        self.itemNote.text! = order.first!.address!
        amount.text! = "$ " + String(format: "%.2f" ,(Double(order.first!.totalPrice!)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let s = dateFormatter.date( from: order.first!.date!)
        orderTime.text! =  s!.timeAgoSinceDate()
         let details = ["courseId": dataTask.LoginData().courseId! , "databaseId" : "\(order.first?.databaseId! ?? 0)"]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.fetchOrders)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let orderDetails = json["orderDetails"] as? [[String:Any]] else {return}
                    self.tip.text! = "Tip: " + "$" + String(format: "%.2f" ,((json["tip"] as? Double ?? 0.00)))
                    if orderDetails.count > 0 {
                        for i in orderDetails {
                            self.orderDetail.append(orderDetailsData(data: i))
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "No data found", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.orderHistoryDetail.reloadData()
                }
            }
        }
    }
    
    @IBAction func chatButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        studentDVC.order = "\(order.first?.databaseId! ?? 0)"
        studentDVC.driverId = "\(order.first?.driver_id! ?? 0)"
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        changeOrderStatus(status: "Cancelled")
    }
    
//MARK: Api Calling
    private func changeOrderStatus(status : String!) {
        FSActivityIndicatorView.shared.show()
        let details = ["courseId": dataTask.LoginData().courseId! , "databaseId" : order.first!.databaseId! , "orderStatus" : "\(status!)" , "cartPhone" : dataTask.LoginData().mobileNo!] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.changeOrderStatus)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        let parameters = ["isNew": false] as [String : Any]
                        NineEighteenSocketIOManager.sharedInstance.socket.emit("orderStatus", with:[parameters])
                        let message = json["message"] as! String
                        FSActivityIndicatorView.shared.dismiss()
                        self.createAlert(message: message)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        let message = json["message"] as? String
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "\(message!)", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
    func createAlert(message:String!) {
        let alert = UIAlertController(title: "Success", message: "\(message!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension OrderHistoryDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryDetailTableViewCell") as! OrderHistoryDetailTableViewCell
        cell.itemName.text! = orderDetail[indexPath.row].name!
        cell.itemCount.text! = "\(orderDetail[indexPath.row].quantity!)" + " Item(s)"
        cell.price.text! = "$ " + String(format: "%.2f" ,(Double(orderDetail[indexPath.row].price!)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 110
        }
        return 90
    }
}
