//
//  OTPViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var otp: UITextField!
    var mobile : String!
    var isForgot : Bool!
    var countryCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
    }
    
//MARK:- API Calling
private func otpApi() {
    FSActivityIndicatorView.shared.show()
    let details = ["phone": mobile! , "status" : "finish" , "verificationCode" : otp.text!,"code" : "+" + countryCode!,"course_id":dataTask.LoginData().courseId!]
   ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.otpApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    print(json)
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                        studentDVC.mobile = self.mobile
                        self.navigationController?.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter correct otp", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
    private func validateOtpApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile! , "otp" : otp.text!,"code" : "+" + countryCode!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.validateApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                        studentDVC.mobile = self.mobile
                        self.navigationController?.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter correct otp", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
    @IBAction func goButton(_ sender: Any) {
        if otp.text!.isEmpty {
          NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter otp", cancelButtonTitle: "OK", presentViewController: self)
        } else {
            if isForgot == true {
                validateOtpApi()
            }
            else {
            otpApi()
            }
        }
    }
}
