//
//  HospitalityMembershipViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityMembershipViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var memberId: UITextField!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var retry: NineEighteenButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var fn: UITextField!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    

override func viewDidLoad() {
    super.viewDidLoad()
    let imageView = UIImageView(image: UIImage(named: "Gradient logo"))
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
    imageView.frame = titleView.bounds
    titleView.addSubview(imageView)
    self.navigationItem.titleView = titleView
}
    
//MARK:- Api Calling
    private func registerMember() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id": dataTask.LoginData().user_id!, "courseId": "" , "req_status" : "1" , "lastName" : userName.text! , "firstName" : fn.text!, "ref_code" : memberId.text! , "remarks" : remarks.text!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.memberApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        NineEighteenApis.firstName = self.fn.text!
                        NineEighteenApis.lastName = self.userName.text!
                        UserDefaults.standard.set(1, forKey: "isMember")
                        let  _ = self.tabBarController?.viewControllers![0] as! UINavigationController
                        self.tabBarController?.selectedIndex = 0
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
