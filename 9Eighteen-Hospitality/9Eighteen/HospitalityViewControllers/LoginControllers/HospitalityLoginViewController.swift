//
//  HospitalityLaunchViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 04/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import NKVPhonePicker

class HospitalityLoginViewController: UIViewController,CountriesViewControllerDelegate {
    
    @IBOutlet weak var nin: UIButton!
    @IBOutlet weak var hiw: UIButton!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    
    
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
    }
    
    //MARK:- API Calling
    private func loginApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["phone": mobileNumber.text!,"country_code" :"+" + countryCode.code! ]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.existsApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["status"] as? Int else {return}
                    if success == 200 {
                        let data = json["data"] as? [String:Any]
                        let exists = data!["exists"] as? Bool
                        if(exists == true) {
                            FSActivityIndicatorView.shared.dismiss()
                            let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
                            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityPasswordViewController") as! HospitalityPasswordViewController
                            studentDVC.mobile = self.mobileNumber.text!
                            studentDVC.isExist = true
                            studentDVC.country_code = self.countryCode.code!
                            self.navigationController?.pushViewController(studentDVC, animated: true)
                        }
                        else if exists == false {
                            FSActivityIndicatorView.shared.dismiss()
                            let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
                            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityOTPViewController") as! HospitalityOTPViewController
                            studentDVC.mobile = self.mobileNumber.text!
                            studentDVC.countryCode = self.countryCode.code!
                            self.navigationController?.pushViewController(studentDVC, animated: true)
                        }
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
    
    @IBAction func loginButton(_ sender: Any) {
        if mobileNumber.text!.isEmpty  {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please enter your mobile number", cancelButtonTitle: "OK", presentViewController: self)
        }
        else {
            loginApi()
        }
    }
    
    @IBAction func forgotButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityForgotPasswordViewController") as! HospitalityForgotPasswordViewController
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

