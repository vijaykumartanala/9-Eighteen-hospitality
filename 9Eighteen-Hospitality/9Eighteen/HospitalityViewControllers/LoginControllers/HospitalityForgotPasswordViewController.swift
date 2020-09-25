//
//  HospitalityForgotPasswordViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 14/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import NKVPhonePicker

class HospitalityForgotPasswordViewController: UIViewController,CountriesViewControllerDelegate{
    
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCode.phonePickerDelegate = self
        countryCode.countryPickerDelegate = self
        countryCode.rightToLeftOrientation = false
        countryCode.shouldScrollToSelectedCountry = false
        countryCode.flagSize = CGSize(width: 30, height: 50)
        countryCode.enablePlusPrefix = false
        countryCode.favoriteCountriesLocaleIdentifiers = ["CA", "US"]
        let country = Country.country(for: NKVSource(countryCode: "CA"))
        countryCode.country = country
        countryCode.text! = ""
    }
    
    @IBAction func goButton(_ sender: Any) {
        if mobile.text!.isEmpty  {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter your mobile number", cancelButtonTitle: "OK", presentViewController: self)
        }
        else {
            forgotPassword()
        }
    }
    
//MARK:- Api Calling
    private func forgotPassword() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile.text!,"country_code" : "+" + countryCode.code!]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.forgotPassword)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
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
                        let id = data!["id"] as? Int
                        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityOTPViewController") as! HospitalityOTPViewController
                        studentDVC.mobile = self.mobile.text!
                        studentDVC.countryCode = self.countryCode.code!
                        studentDVC.isForgot = true
                        studentDVC.user_id = "\(id!)"
                        self.navigationController?.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        let message = json["message"] as? String
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "\(message!)", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
//TextField Delgate Methods
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("helo")
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        countryCode.text! = ""
    }
    
}
