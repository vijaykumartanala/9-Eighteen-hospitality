//
//  NotificationViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 15/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableview: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    var notifications = [notificationsData]()
    var window: UIWindow?
    var from : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notifications"
        notificationTableview.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch{
            notificationApi()
            backgroundView.isHidden = true
            self.notificationTableview.isHidden = false
        }else{
            backgroundView.isHidden = false
            self.notificationTableview.isHidden = true
        }
    }
    
    //MARK:- Api calling
    private func notificationApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id" : "\(dataTask.LoginData().user_id!)","sender": 2] as [String:Any]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.getNotifications)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        let results = json["results"] as! [[String:Any]]
                        if results.count == 0 {
                            self.bgLabel(message: "No Notifications Received")
                        }
                        else {
                            for i in results {
                                self.notifications.append(notificationsData(data: i))
                            }
                        }
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.notificationTableview.reloadData()
                }
            }
        }
    }
    
    private func bgLabel(message : String!) {
        self.notificationTableview.isHidden = true
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = UIColor.darkGray
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

extension NotificationViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.message.text! = notifications[indexPath.row].notification
        if notifications[indexPath.row].type == "chat" {
            cell.arrow.isHidden = false
        }
        else {
            cell.arrow.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifications[indexPath.row].type == "chat" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            studentDVC.order = "\(notifications[indexPath.row].order_id!)"
            studentDVC.driverId = "\(notifications[indexPath.row].driver_id!)"
            navigationController?.pushViewController(studentDVC, animated: true)
        }
        else {}
    }
}
