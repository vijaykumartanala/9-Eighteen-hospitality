//
//  HospitalityHistoryDetailViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 05/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityHistoryDetailViewController: UIViewController {
    
    var order = [hospitalityorderData]()
    let label = UILabel()
    var orderItem = [orderItems]()
    
    @IBOutlet weak var orderHistoryDetailTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var cancelledButton: NineEighteenButton!
    @IBOutlet weak var chatButton: NineEighteenButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        chatButton.isHidden = true
        self.navigationItem.title = "Order Detail"
        orderHistoryDetailTableView.register(UINib(nibName: "HospitalityOrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalityOrderHistoryTableViewCell")
        if((order.first?.status == "Cancelled") || (order.first?.status == "Completed")){
            cancelledButton.isHidden = true
        }
        if(order.first?.status == "Reserved"){
            cancelledButton.isHidden = true
            chatButton.isHidden = false
        }
        if(order.first?.status == "Ready For Delivery"){
            cancelledButton.isHidden = true
            chatButton.isHidden = false
        }
        if(order.first?.status == "Driver Assigned"){
            cancelledButton.isHidden = true
            chatButton.isHidden = false
        }
        customData()
    }
    
    private func customData(){
        fetchOrdersApi()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let s = dateFormatter.date( from: (order.first?.order_date!)!)
        userName.text! = order.first!.name!
        tip.text! = "TIP : " + " $ " + String(format: "%.2f" ,(Double((order.first?.tip!)!)))
        orderId.text! = "Order Id :- " + "\(String(describing: order.first!.id!))"
        amount.text! = "$ " + String(format: "%.2f" ,(Double((order.first?.total_amount!)!)))
        orderTime.text! =  s!.timeAgoSinceDate()
        itemCount.text! = "\(String(describing: order.first!.tbl_order_item_details.count))" + " Item (s)"
        status.text! = (order.first?.status!)!
        locationButton.isHidden = true
        if((order.first!.delivery_type == 1) || order.first!.delivery_type == 3 ){
            locationButton.isHidden = false
        }
    }
    
    private func fetchOrdersApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["id" : order.first!.id!] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: HospitalityNineEighteenApis.shared.resortOrder)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let orderInfo = json["data"] as? [String:Any] else {return}
                    if orderInfo["count"] as? Int == 0 {
                        self.bgLabel(message: "No orders found", status: true)
                    }
                    else if (orderInfo["count"] as? Int)! > 0 {
                        let rows = orderInfo["rows"] as? [[String:Any]]
                        let tbl_order = rows![0]["tbl_order_item_details"] as? [[String:Any]]
                        for i in tbl_order! {
                            self.orderItem.append(orderItems(data: i))
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.orderHistoryDetailTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func locationButton(_ sender: Any) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "questionsViewController") as!  questionsViewController
        newViewcontroller.fromHistory = true
        newViewcontroller.order = order
        newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
            self.present(newViewcontroller, animated: true, completion:nil)
        })
    }
    
    @IBAction func chatButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityChatViewController") as! HospitalityChatViewController
        studentDVC.order = "\(order.first?.id ?? 0)"
        studentDVC.driverId = "\(order.first?.driver_id ?? 0)"
        studentDVC.bussinessId = "\(order.first?.business_id ?? 0)"
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.createAlert(message: "Are sure you want to cancel order?")
    }
    
    private func changeHospitalityOrderStatus() {
        FSActivityIndicatorView.shared.show()
        let details = ["orderStatus":"Cancelled","order_id":order.first!.id!] as [String : Any]
            ModelParser.postApiServices(urlToExecute: URL(string: HospitalityNineEighteenApis.shared.changeHospitalityPaymentStatus)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
                DispatchQueue.main.async {
                    if let unwrappedError = error {
                        FSActivityIndicatorView.shared.dismiss()
                        print(unwrappedError.localizedDescription)
                    }
                    if let json = response {
                        FSActivityIndicatorView.shared.dismiss()
                        guard let success = json["status"] as? Int else {return}
                        if success == 200 {
                            let parameters = ["isNew": false] as [String : Any]
                    HospitalitySocketIOManager.hospitalitySharedInstance.hospitalitySocket.emit("orderStatus", with:[parameters])
                           self.navigationController?.popViewController(animated: true)
                        }
                        else {
                    NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                        }
                    }
                }
            }
        }
    
    func createAlert(message:String!) {
        let alert = UIAlertController(title: "Alert", message: "\(message!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.changeHospitalityOrderStatus()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func bgLabel(message : String!,status:Bool) {
        self.orderHistoryDetailTableView.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        if(status == true){
            label.textColor = UIColor.white
        }else{
            label.textColor = UIColor.darkGray
        }
        label.font = UIFont(name: "Poppins-Regular", size: 16.0)
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension HospitalityHistoryDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalityOrderHistoryTableViewCell") as! HospitalityOrderHistoryTableViewCell
        cell.itemName.text! = orderItem[indexPath.row].itemName!
        cell.quantity.text! = "\(orderItem[indexPath.row].quantity!)" + " Item (s)"
        cell.itemCost.text! = "$ " + String(format: "%.2f" ,(Double(orderItem[indexPath.row].price!)))
        if(orderItem[indexPath.row].orderTopping.count == 0){
            cell.toppingsButton.isHidden = true
        }else{
            cell.history = self
            cell.toppingsDetails(toppingDetail: orderItem[indexPath.row].topOrders)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 110
        }
        return 90
    }
}
