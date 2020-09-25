//
//  OrderHistoryViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 16/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var orderhistoryTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var order = [orderData]()
    var window: UIWindow?
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        if NineEighteenApis.exits == true {
            self.bgLabel(message: "Hey, we noticed you’re not currently on a 9-eighteen partnered course, as soon as you get in range of one a full menu will be updated.",status: false)
            backgroundView.isHidden = true
            self.orderhistoryTableView.isHidden = true
        }else{
            let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
            if isFirstLaunch {
                fetchOrdersApi()
                order.removeAll()
                backgroundView.isHidden = true
                self.orderhistoryTableView.isHidden = false
            }else{
                self.orderhistoryTableView.isHidden = true
                backgroundView.isHidden = false
            }
        }
    }
    
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    private func customMethod() {
        self.navigationItem.title = "Order History"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        orderhistoryTableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryTableViewCell")
        orderhistoryTableView.tableFooterView = UIView()
        appdelegate.notificationcenter.addObserver(self, selector: #selector(showCounter), name: Notification.Name("recivedPushN"), object: nil)
        showCounter()
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: false)
    }
    
    @objc private func fetchNewMessages(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let newList = userInfo["newChat"] as! [[String:Any]]
            print(newList)
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
    
//MARK:- API Calling
    private func fetchOrdersApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["courseId": dataTask.LoginData().courseId!,"user_id" : dataTask.LoginData().user_id!] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.fetchOrders)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let orderInfo = json["order"] as? [[String:Any]] else {return}
                    if orderInfo.count == 0 {
                        self.bgLabel(message: "No orders found", status: true)
                    }
                    else if orderInfo.count > 0 {
                        for i in orderInfo {
                            self.order.append(orderData(data: i))
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.orderhistoryTableView.reloadData()
                }
            }
        }
    }
    
    private func bgLabel(message : String!,status:Bool) {
        self.orderhistoryTableView.isHidden = true
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
    
    @IBAction func signupButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVc = UINavigationController(rootViewController: initialViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
    }
}

extension OrderHistoryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let s = dateFormatter.date( from: order[indexPath.row].date!)
        cell.resName.text! = order[indexPath.row].courseName!
        cell.userName.text! = "Order Id :- " + "\(String(describing: order[indexPath.row].databaseId!))"
        cell.amount.text! = "$ " + String(format: "%.2f" ,(Double(order[indexPath.row].totalPrice!)))
        cell.orderTime.text! =  s!.timeAgoSinceDate()
        cell.itemsCount.text! = "\(String(describing: order[indexPath.row].count!))" + " Item(s)"
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "OrderHistoryDetailViewController") as! OrderHistoryDetailViewController
        studentDVC.order = [order[indexPath.row]]
        navigationController?.pushViewController(studentDVC, animated: true)
    }
}
