//
//  HospitalityPasswordViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 08/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityPasswordViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var hide: UIButton!
    
    var iconClick : Bool!
    var mobile : String!
    var isExist : Bool!
    var country_code : String!
    var user_id : String!
    
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
    //MARK:- Api Method's
    private func passwordApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile! , "password" : password.text!,"country_code":"+" + country_code,"user_id":user_id!]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.resetPassword)!, parameters: details as [String : Any], methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["status"] as? Int else {return}
                    if success == 200 {
                        FSActivityIndicatorView.shared.dismiss()
                        let data = json["data"] as? [String:Any]
                        UserDefaults.standard.set(data!["id"] as? Int, forKey: "user_id")
                        UserDefaults.standard.set(true, forKey: "hospitalityloginsuccess")
                        UserDefaults.standard.set(self.mobile, forKey: "mobileNumber")
                        UserDefaults.standard.set(data!["token"] as? String, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isFrom")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.hospitalityAutoLogin()
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
        let details = ["phone": mobile! , "password" : password.text!,"country_code":"+" + country_code]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.userLogin)!, parameters: details as [String : Any], methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        FSActivityIndicatorView.shared.dismiss()
                        let data = json["data"] as? [String:Any]
                        UserDefaults.standard.set(data!["id"] as? Int, forKey: "user_id")
                        UserDefaults.standard.set(true, forKey: "hospitalityloginsuccess")
                        UserDefaults.standard.set(self.mobile, forKey: "mobileNumber")
                        UserDefaults.standard.set(data!["token"] as? String, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isFrom")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.hospitalityAutoLogin()
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
    
    @IBAction func passwordButton(_ sender: Any) {
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
}
