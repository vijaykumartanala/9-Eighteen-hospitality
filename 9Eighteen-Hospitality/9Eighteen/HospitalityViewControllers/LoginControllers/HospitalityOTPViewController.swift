//
//  HospitalityOTPViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 08/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityOTPViewController: UIViewController {
    
    var mobile : String!
    var isForgot : Bool!
    var countryCode : String!
    var user_id :String!
    
    @IBOutlet weak var otp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//MARK:- API Calling
    private func otpApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile! , "status" : "finish" , "verification_code" : otp.text!,"country_code" : "+" + countryCode!]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.verifySms)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    print(json)
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["status"] as? Int else {return}
                    if success == 200 {
                        FSActivityIndicatorView.shared.dismiss()
                        let data = json["data"] as? [String:Any]
                        let user_id = data!["user_id"] as? String
                        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityPasswordViewController") as! HospitalityPasswordViewController
                        studentDVC.mobile = self.mobile
                        studentDVC.user_id = user_id
                        studentDVC.country_code = self.countryCode
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
        let details = ["phone": mobile! , "otp" : otp.text!,"country_code" : "+" + countryCode!,"user_id":user_id]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.validateOtp)!, parameters: details as [String : Any], methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["status"] as? Int else {return}
                    if success == 200 {
                        FSActivityIndicatorView.shared.dismiss()
                        let data = json["data"] as? [String:Any]
                        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityPasswordViewController") as! HospitalityPasswordViewController
                        studentDVC.mobile = self.mobile
                        studentDVC.user_id = data!["user_id"] as? String
                        studentDVC.country_code = self.countryCode
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
    
    @IBAction func otpButton(_ sender: Any) {
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
