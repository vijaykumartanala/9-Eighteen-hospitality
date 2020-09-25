//
//  ViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import NKVPhonePicker

class LoginViewController: UIViewController,CountriesViewControllerDelegate {

    var iconClick : Bool!
    
    @IBOutlet weak var nin: UIButton!
    @IBOutlet weak var hiw: UIButton!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    @IBOutlet weak var checkbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nin.centerImageAndButton(8, imageOnTop: true)
        hiw.centerImageAndButton(8, imageOnTop: true)
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
    }
    
    //MARK:- API Calling
    private func loginApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobileNumber.text!,"code" : "+" + countryCode.code! ]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.existApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    let isNew = json["exists"] as? Bool
                    if success == true && isNew == true {
                        FSActivityIndicatorView.shared.dismiss()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                        studentDVC.mobile = self.mobileNumber.text!
                        studentDVC.isExist = true
                        self.navigationController?.pushViewController(studentDVC, animated: true)
                    }
                    else if isNew == false {
                        FSActivityIndicatorView.shared.dismiss()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        studentDVC.mobile = self.mobileNumber.text!
                        studentDVC.countryCode = self.countryCode.code!
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
    
    @IBAction func loginButton(_ sender: UIButton) {
        if mobileNumber.text!.isEmpty {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter your mobile number", cancelButtonTitle: "OK", presentViewController: self)
        }
        else if((iconClick == true)){
            loginApi()
        }
        else {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please agree terms & conditions of 9-Eighteen", cancelButtonTitle: "OK", presentViewController: self)
        }
    }
    
    @IBAction func checkboxButton(_ sender: Any) {
        if iconClick == false {
            iconClick = true
        } else {
            iconClick = false
        }
        if iconClick == true {
            checkbox.setImage(UIImage(named: "checkbox"), for: UIControlState.normal)
        }
        else {
            checkbox.setImage(UIImage(named: "check-box-empty"), for: UIControlState.normal)
        }
    }
    
    @IBAction func tcButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "CommingSoonViewController") as! CommingSoonViewController
        self.navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func nineButton(_ sender: Any) {
        guard let url = URL(string: "https://www.9-eighteen.com/") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBAction func howButton(_ sender: UIButton) {
        guard let url = URL(string: "https://www.9-eighteen.com/") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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

