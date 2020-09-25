//
//  HospitalityTabbarControllerViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityTabbarControllerViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBar.unselectedItemTintColor = UIColor.white
//        UINavigationBar.appearance().backgroundColor = UIColor.white
//        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 20.0))
//        statusBarView.backgroundColor = UIColor.white
//        self.navigationController?.view.addSubview(statusBarView)
    }
}

