//
//  HospitalityNotificationViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 23/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityNotificationViewController: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
     var notifications = [hospitalityNotificationsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notifications"
        notificationsTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        notificationApi()
    }
    
//MARK:- Api calling
       private func notificationApi() {
           FSActivityIndicatorView.shared.show()
           let details = ["user_id" : "\(dataTask.LoginData().user_id!)","sender": [2,3]] as [String:Any]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.getNotifications)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
               DispatchQueue.main.async {
                   FSActivityIndicatorView.shared.dismiss()
                   if let unwrappedError = error {
                       print(unwrappedError.localizedDescription)
                   }
                   if let json = response {
                       FSActivityIndicatorView.shared.dismiss()
                       guard let success = json["status"] as? Int else {return}
                       if success == 200 {
                           let data = json["data"] as? [String:Any]
                        let results = data!["results"] as! [[String:Any]]
                           if results.count == 0 {
                               self.bgLabel(message: "No Notifications Received")
                           }
                           else {
                               for i in results {
                                   self.notifications.append(hospitalityNotificationsData(data: i))
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
                       self.notificationsTableView.reloadData()
                   }
               }
           }
       }
       
       private func bgLabel(message : String!) {
           self.notificationsTableView.isHidden = true
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

}

extension HospitalityNotificationViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.message.text! = notifications[indexPath.row].notification
        cell.arrow.isHidden = true
//        if notifications[indexPath.row].type == "chat" {
//            cell.arrow.isHidden = false
//        }
//        else {
//            cell.arrow.isHidden = true
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if notifications[indexPath.row].type == "chat" {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//            studentDVC.order = "\(notifications[indexPath.row].order_id!)"
//            studentDVC.driverId = "\(notifications[indexPath.row].driver_id!)"
//            navigationController?.pushViewController(studentDVC, animated: true)
//        }
//        else {}
//    }
}
