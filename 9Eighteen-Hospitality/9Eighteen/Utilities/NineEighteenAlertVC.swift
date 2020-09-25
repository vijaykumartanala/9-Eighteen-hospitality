//
//  FSAlertController.swift
//  FanStar
//
//  Created by Kumar, Sravan on 11/05/18.
//  Copyright © 2018 Kumar, Sravan. All rights reserved.
//

import UIKit
typealias alertCompletionHandler = (_ actionTitle: String) -> Void

class NineEighteenAlertController: NSObject {
    
    class func showCancelAlertController(title: String?, message: String?, cancelButtonTitle: String?, presentViewController: UIViewController) -> Void {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        presentViewController.present(controller, animated: true, completion: nil)
    }
    
    class func showAlertWithAction(title: String?, message: String?, cancelButtonTitle: String?, presentViewController: UIViewController, completionHandler: @escaping alertCompletionHandler){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
            completionHandler(action.title!)
        })
        controller.addAction(cancelAction)
        presentViewController.present(controller, animated: true, completion: nil)
    }
    
    class func showAlertController(title: String?, message: String?, cancelButtonTitle: String?, otherButtonTitles: [String]?, presentViewController: UIViewController, completionHandler: @escaping alertCompletionHandler) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        if let otherButtons = otherButtonTitles {
            for otherButtonTitle in otherButtons {
                let action = UIAlertAction(title: otherButtonTitle, style: .default, handler: { (action) in
                    completionHandler(action.title!)
                })
                controller.addAction(action)
            }
        }
        presentViewController.present(controller, animated: true, completion: nil)
    }
    
    class func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    class func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d\\S]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
}

extension UIViewController {
    
    func addBadge(itemvalue: String,isCart : Bool,isHospitality:Bool) {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        if(isCart == true){
            bagButton.setImage(UIImage(named: "cart_2")?.withRenderingMode(.alwaysTemplate), for: .normal)
            bagButton.addTarget(self, action: #selector(moveToCart), for: UIControlEvents.touchUpInside)
            bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        }else if(isCart == true && isHospitality == true){
            bagButton.setImage(UIImage(named: "cart_2")?.withRenderingMode(.alwaysTemplate), for: .normal)
            bagButton.addTarget(self, action: #selector(moveToHospitalityCart), for: UIControlEvents.touchUpInside)
            bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        }
            
        else{
            if(isHospitality == true && isCart == false){
                bagButton.setImage(UIImage(named: "Icon ionic-ios-notifications-outline")?.withRenderingMode(.alwaysOriginal), for: .normal)
                bagButton.addTarget(self, action: #selector(clickHospitalityButton), for: UIControlEvents.touchUpInside)
                bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            }else{
                bagButton.setImage(UIImage(named: "notifications_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
                bagButton.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
                bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            }
        }
        bagButton.badge = itemvalue
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-150 , y: self.view.frame.size.height - 150, width: 300, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc func clickButton() {
        UserDefaults.standard.set(0,forKey: "badgeCount")
        dataTask.badgeCount = 0
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @objc func clickHospitalityButton() {
        UserDefaults.standard.set(0,forKey: "badgeCount")
        dataTask.badgeCount = 0
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityNotificationViewController") as! HospitalityNotificationViewController
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @objc func moveToCart() {
        let  _ = self.tabBarController?.viewControllers![1] as! UINavigationController
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func  moveToHospitalityCart(){
        let  _ = self.tabBarController?.viewControllers![1] as! UINavigationController
        self.tabBarController?.selectedIndex = 1
    }
}
