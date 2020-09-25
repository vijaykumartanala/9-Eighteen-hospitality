//
//  LaunchViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 23/02/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func hospitalityButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "hospitalityloginsuccess")
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityLoginViewController") as! HospitalityLoginViewController
        self.navigationController?.pushViewController(studentDVC, animated: true)

    }
    
    @IBAction func golfButton(_ sender: Any) {
       UserDefaults.standard.removeObject(forKey: "loginsuccess")
       let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(studentDVC, animated: true)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "NineEighteenViewController") as! NineEighteenViewController
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }
    }
}
