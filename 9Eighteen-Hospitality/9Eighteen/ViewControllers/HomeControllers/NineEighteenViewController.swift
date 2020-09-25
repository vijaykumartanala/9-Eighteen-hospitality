//
//  NineEighteenViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 11/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class NineEighteenViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let selectedColor   = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
    //        self.delegate = self
//    UITabBarControllerDelegate
//        if let vc = viewController as? UINavigationController
//        { vc.popToRootViewController(animated: false) }
//    }
}
