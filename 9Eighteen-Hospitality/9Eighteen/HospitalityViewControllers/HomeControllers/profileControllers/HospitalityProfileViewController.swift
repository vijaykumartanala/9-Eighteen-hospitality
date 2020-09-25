//
//  ProfileViewController.swift
//  9Eighteen
//  Created by Vijaykumar Tanala on 04/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import Kingfisher

class HospitalityProfileViewController: UIViewController {
    
    @IBOutlet weak var fn: UILabel!
    @IBOutlet weak var ln: UILabel!
    @IBOutlet weak var pn: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var imageUrl : String?
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    
    private func customUI() {
        showCounter()
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        profilePic.layer.borderWidth = 3
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor(hexString: "#0C6E4C").cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileApi()
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
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: true)
    }
    
    private func profileApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id": dataTask.LoginData().user_id!]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.getProfile)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    print(json)
                    if let success = json["status"] as? Int {
                        if success == 200 {
                            FSActivityIndicatorView.shared.dismiss()
                            let results = json["data"] as! [String:Any]
                            self.fn.text! = results["first_name"] as? String ?? "-"
                            self.ln.text! = results["last_name"] as? String ?? "-"
                            self.pn.text! = results["phone"] as? String ?? "-"
                            self.email.text! = results["email"] as? String ?? "-"
                            self.profilePic.kf.setImage(with: URL(string: results["profile_path"] as? String ?? ""), placeholder: UIImage(named: "user"))
                            self.imageUrl = results["profile_path"] as? String ?? ""
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
    
    @IBAction func editButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityChangePasswordViewController") as! HospitalityChangePasswordViewController
        studentDVC.isEdit = true
        studentDVC.imageUrl = self.imageUrl
        self.navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func password(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityChangePasswordViewController") as! HospitalityChangePasswordViewController
        self.navigationController?.pushViewController(studentDVC, animated: true)
        
    }
    
    @IBAction func logoutButton(_ sender: NineEighteenButton) {
        createAlert()
    }
    
    func createAlert(){
        let alert = UIAlertController(title: "Logout", message: " Are you sure you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            HospitalityNineEighteenApis.isSelected = false
            NineEighteenApis.isBackground = false
            self.logoutApi(user_id: dataTask.LoginData().user_id!)
            UserDefaults.standard.removeObject(forKey: "hospitalityloginsuccess")
            UserDefaults.standard.removeObject(forKey: "hospitalitycourseId")
            UserDefaults.standard.removeObject(forKey: "mobileNumber")
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "user_id")
            CoreDataStack.shared.deleteOrderedItems()
            HospitalitySocketIOManager.hospitalitySharedInstance.hospitalityCloseConnection()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
            let navVc = UINavigationController(rootViewController: initialViewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVc
            self.window?.makeKeyAndVisible()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logoutApi(user_id:String!) {
        let details = ["type": "user" , "user_id" : user_id]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.logoutApi)!, parameters: details as [String : Any], methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let _ = response {
                }
            }
        }
    }
}

