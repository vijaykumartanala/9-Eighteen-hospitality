//
//  ForgotPasswordViewController.swift
//  9Eighteen
//
//  Created by vijaykumar on 06/08/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import NKVPhonePicker
class ForgotPasswordViewController: UIViewController,CountriesViewControllerDelegate {

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
    
    private func forgotPassword() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobile.text!,"code" : "+" + countryCode.code!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.forgotApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
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
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        studentDVC.mobile = self.mobile.text!
                        studentDVC.countryCode = self.countryCode.code!
                        studentDVC.isForgot = true
                        self.navigationController?.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter a valid mobile number", cancelButtonTitle: "OK", presentViewController: self)
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
