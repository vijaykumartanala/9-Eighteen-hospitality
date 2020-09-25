//
//  HospitalityHistoryViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityHistoryViewController: UIViewController {
    
    @IBOutlet weak var hospitalityHistoryTableView: UITableView!
    
    var order = [hospitalityorderData]()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalityHistoryTableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryTableViewCell")
        hospitalityHistoryTableView.tableFooterView = UIView()
        showCounter()
        customUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrdersApi()
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
    
    private func customUI() {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: true)
    }
    
    //MARK:- API Calling
    private func fetchOrdersApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id" : dataTask.LoginData().user_id!] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: HospitalityNineEighteenApis.shared.resortOrder)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    self.order.removeAll()
                    FSActivityIndicatorView.shared.dismiss()
                    guard let orderInfo = json["data"] as? [String:Any] else {return}
                    if orderInfo["count"] as? Int == 0 {
                        self.bgLabel(message: "No orders found", status: true)
                    }
                    else if (orderInfo["count"] as? Int)! > 0 {
                        let rows = orderInfo["rows"] as? [[String:Any]]
                        for i in rows! {
                            self.order.append(hospitalityorderData(data: i))
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.hospitalityHistoryTableView.reloadData()
                }
            }
        }
    }
    
    private func bgLabel(message : String!,status:Bool) {
        self.hospitalityHistoryTableView.isHidden = true
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

extension HospitalityHistoryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let s = dateFormatter.date( from: order[indexPath.row].order_date!)
        cell.resName.text! = order[indexPath.row].name
        cell.userName.text! = "Order Id :- " + "\(String(describing: order[indexPath.row].id!))"
        cell.amount.text! = "$ " + String(format: "%.2f" ,(Double(order[indexPath.row].total_amount!)))
        cell.orderTime.text! =  s!.timeAgoSinceDate()
        cell.itemsCount.text! = "\(String(describing: order[indexPath.row].tbl_order_item_details.count))" + " Item (s)"
        cell.status.text! = order[indexPath.row].status!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        }
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityHistoryDetailViewController") as! HospitalityHistoryDetailViewController
        studentDVC.order = [order[indexPath.row]]
        self.navigationController?.pushViewController(studentDVC, animated: true)
    }
    
}
