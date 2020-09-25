//
//  PasswordViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 26/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    var mobile : String!
    var isExist : Bool!
    var iconClick : Bool!
    
    
    @IBOutlet weak var hide: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func show(_ sender: Any) {
        if iconClick == false {
            iconClick = true
        } else {
            iconClick = false
            
        }
        if iconClick == true {
            hide.setImage(UIImage(named: "hide"), for: UIControlState.normal)
            password.isSecureTextEntry = true
            
        }
        else {
            hide.setImage(UIImage(named: "view"), for: UIControlState.normal)
            password.isSecureTextEntry = false
        }
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        if password.text!.isEmpty {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter password", cancelButtonTitle: "OK", presentViewController: self)
        }
        else {
            if isExist == true {
                loginApi()
            } else {
                passwordApi()
                
            }
        }
    }
    
    private func passwordApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phoneNumber": mobile! , "password" : password.text!,"foreupCourseId":dataTask.LoginData().forupId!,"course_id":dataTask.LoginData().courseId!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.passwordApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        UserDefaults.standard.set(json["user_id"] as? String, forKey: "user_id")
                        UserDefaults.standard.set(self.mobile, forKey: "mobileNumber")
                        UserDefaults.standard.set(true, forKey: "loginsuccess")
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                        UserDefaults.standard.set(false, forKey: "isFrom")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.autoLogin()
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        guard let message = json["message"] as? String else {return}
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "\(message)", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
    private func loginApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile! , "password" : password.text!,"course_id":dataTask.LoginData().courseId!,"foreupCourseId":dataTask.LoginData().forupId!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.loginApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        UserDefaults.standard.set(json["userId"] as? String, forKey: "user_id")
                        UserDefaults.standard.set(true, forKey: "loginsuccess")
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                        UserDefaults.standard.set(self.mobile, forKey: "mobileNumber")
                        UserDefaults.standard.set(false, forKey: "isFrom")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.autoLogin()
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        guard let message = json["message"] as? String else {return}
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "\(message)", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
}
