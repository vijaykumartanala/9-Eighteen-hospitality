//
//  ProfileViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 15/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    var window: UIWindow?
    
    @IBOutlet weak var fn: UILabel!
    @IBOutlet weak var ln: UILabel!
    @IBOutlet weak var pn: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var imageUrl : String?
    var foreUp : String?
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var bgScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        profilePic.layer.borderWidth = 3
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor(hexString: "#0C6E4C").cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            bgScroll.isHidden = false
            backgroundView.isHidden = true
            profileApi()
        }else{
            bgScroll.isHidden = true
            backgroundView.isHidden = false
        }
    }
    
    //MARK:- Menu Api
    private func profileApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id": dataTask.LoginData().user_id!,"foreupCourseId":dataTask.LoginData().forupId!,"course_id":dataTask.LoginData().courseId!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.getProfile)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    if let success = json["success"] as? Bool {
                        if success == true {
                            FSActivityIndicatorView.shared.dismiss()
                            let results = json["results"] as! [String:Any]
                            self.fn.text! = results["firstName"] as? String ?? "-"
                            self.ln.text! = results["lastName"] as? String ?? "-"
                            self.pn.text! = results["phone"] as? String ?? "-"
                            self.email.text! = results["email"] as? String ?? "-"
                            self.foreUp = results["foreup_user_id"] as? String ?? "null"
                            self.profilePic.sd_setImage(with: URL(string: results["profile_path"] as? String ?? ""), placeholderImage: UIImage(named: "user"))
                            self.imageUrl = results["profile_path"] as? String ?? ""
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
    
    @IBAction func editButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        studentDVC.isEdit = true
        studentDVC.firstName = fn.text!
        studentDVC.lastName = ln.text!
        studentDVC.email = email.text!
        studentDVC.imageUrl = self.imageUrl
        studentDVC.foreup_user_id = self.foreUp
        self.navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    @IBAction func password(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(studentDVC, animated: true)
        
    }
    
    @IBAction func logoutButton(_ sender: NineEighteenButton) {
        createAlert()
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVc = UINavigationController(rootViewController: initialViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
    }
    
    func createAlert(){
        let alert = UIAlertController(title: "Logout", message: " Are you sure you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.logoutApi(user_id: dataTask.LoginData().user_id!)
            NineEighteenApis.isCourseSelected = false
            NineEighteenApis.isShow = false
            NineEighteenApis.exits = false
            NineEighteenApis.isBackground = false
            NineEighteenApis.currencyCode = ""
            UserDefaults.standard.removeObject(forKey: "loginsuccess")
            UserDefaults.standard.removeObject(forKey: "mobileNumber")
            UserDefaults.standard.removeObject(forKey: "isMember")
            UserDefaults.standard.removeObject(forKey: "courseName")
            UserDefaults.standard.removeObject(forKey: "courseId")
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "foreupId")
            UserDefaults.standard.removeObject(forKey: "isFirstLaunch")
            UserDefaults.standard.removeObject(forKey: "user_id")
            CoreDataStack.shared.deleteContext()
            NineEighteenSocketIOManager.sharedInstance.closeConnection()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
            let navVc = UINavigationController(rootViewController: initialViewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVc
            self.window?.makeKeyAndVisible()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logoutApi(user_id:String!) {
          let details = ["type": "user" , "user_id" : user_id]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.logoutApi)!, parameters: details as [String : Any], methodType: "POST", accessToken: false) { (response,error) in
              DispatchQueue.main.async {
                  if let unwrappedError = error {
                      print(unwrappedError.localizedDescription)
                  }
                  if let json = response {
                      if let success = json["success"] as? Bool {
                          if success == true {
                          }
                          else {
                              
                          }
                      }
                  }
              }
          }
      }
}
