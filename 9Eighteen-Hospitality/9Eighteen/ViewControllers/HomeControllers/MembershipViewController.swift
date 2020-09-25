//
//  MembershipViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 15/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class MembershipViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var memberId: UITextField!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var retry: NineEighteenButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var fn: UITextField!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var window: UIWindow?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegate.notificationcenter.addObserver(self, selector: #selector(showCounter), name: Notification.Name("recivedPushN"), object: nil)
        self.navigationItem.title = "MEMBERSHIP"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    @IBAction func retryButton(_ sender: Any) {
        retry.isHidden = false
        memberView.isHidden = true
    }
    
    @IBAction func register(_ sender: Any) {
        if memberId.text!.isEmpty || userName.text!.isEmpty || remarks.text!.isEmpty {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "All fields are manidtory", cancelButtonTitle: "OK", presentViewController: self)
        }
        else {
            registerMember()
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVc = UINavigationController(rootViewController: initialViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCounter()
        label.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if NineEighteenApis.exits == true {
            self.bgLabel(message: "Hey, we noticed you’re not currently on a 9-eighteen partnered course, as soon as you get in range of one a full menu will be updated.")
            backgroundView.isHidden = true
            bgView.isHidden = true
        }else{
             label.isHidden = true
            if isFirstLaunch {
                backgroundView.isHidden = true
                bgView.isHidden = false
                if dataTask.LoginData().member! == 2 {
                    memberView.isHidden = false
                    message.text! = "You are already a member."
                    retry.isHidden = true
                    statusImage.image = UIImage(named: "suc")
                }
                else if dataTask.LoginData().member! == 1 {
                     memberView.isHidden = false
                     message.text! = "Golf admin will review your profile and then accept you as a member. You can then charge your member account."
                    retry.isHidden = true
                    statusImage.image = UIImage(named: "pending")
                }
                else if dataTask.LoginData().member! == 3 {
                    message.text! = "Your membership request is rejected."
                    statusImage.image = UIImage(named: "rejected")
                    retry.isHidden = false
                }
                else {
                    memberView.isHidden = true
                    message.text! = "You are already a member."
                    retry.isHidden = true
                    statusImage.image = UIImage(named: "suc")
                }
            } else {
                backgroundView.isHidden = false
                bgView.isHidden = true
            }
        }
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
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
    
    private func bgLabel(message : String!) {
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = UIColor.white
        label.font = UIFont(name: "Poppins-Regular", size: 16.0)
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        navigationController?.pushViewController(studentDVC, animated: true)
        
    }
    
    private func registerMember() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id": dataTask.LoginData().user_id!, "courseId": dataTask.LoginData().courseId! , "req_status" : "1" , "lastName" : userName.text! , "firstName" : fn.text!, "ref_code" : memberId.text! , "remarks" : remarks.text!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.memberApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        NineEighteenApis.firstName = self.fn.text!
                        NineEighteenApis.lastName = self.userName.text!
                        UserDefaults.standard.set(1, forKey: "isMember")
                        let  _ = self.tabBarController?.viewControllers![0] as! UINavigationController
                        self.tabBarController?.selectedIndex = 0
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
}
