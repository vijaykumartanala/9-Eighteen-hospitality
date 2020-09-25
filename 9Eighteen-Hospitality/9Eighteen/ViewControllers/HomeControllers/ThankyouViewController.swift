//
//  ThankyouViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 15/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ThankyouViewController: UIViewController {
    
    @IBOutlet weak var gifImage: UIImageView!
    var orderKey : String?
    var orderStatus : Bool?
    var orderFrom : Bool?
    var delivery_type : Int!
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var thankslabel: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var bgColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "ORDER CONFIRMATION"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        if(orderFrom == true){
            if orderStatus == true {
                bgColor.backgroundColor = UIColor.init(hexString: "#EEEFEE")
                gifImage.loadGif(name: "success")
                orderId.text! = "ORDER ID - \(orderKey!)"
                thankslabel.text! = "THANK YOU"
                order.text! = "Thank you for your 9-Eighteen order!"
                if(delivery_type == 2){
                  NineEighteenApis.isBackground = true
                }
            } else if orderStatus == false {
                bgColor.backgroundColor = UIColor.white
                gifImage.image = UIImage(named: "pf")
                thankslabel.text! = ""
                order.text! = ""
                orderId.text! = "This transaction has been declined. Please try a different card or contact the credit card provider for assistance."
                NineEighteenApis.isBackground = false
            } else {
                thankslabel.text! = ""
                order.text! = ""
                let tabbar: UITabBarController? = (storyboard!.instantiateViewController(withIdentifier: "HospitalityTabbarControllerViewController") as? HospitalityTabbarControllerViewController)
                NineEighteenApis.isBackground = false
                NineEighteenApis.message = "   type message here..."
                navigationController?.pushViewController(tabbar!, animated: true)
            }
        }else{
            if orderStatus == true {
                bgColor.backgroundColor = UIColor.init(hexString: "#EEEFEE")
                gifImage.loadGif(name: "success")
                orderId.text! = "ORDER ID - \(orderKey!)"
                thankslabel.text! = "THANK YOU"
                order.text! = "Thank you for your 9-Eighteen order!"
                NineEighteenApis.isBackground = true
            } else if orderStatus == false {
                bgColor.backgroundColor = UIColor.white
                gifImage.image = UIImage(named: "pf")
                thankslabel.text! = ""
                order.text! = ""
                orderId.text! = "This transaction has been declined. Please try a different card or contact the credit card provider for assistance."
                NineEighteenApis.isBackground = false
            } else {
                thankslabel.text! = ""
                order.text! = ""
                let tabbar: UITabBarController? = (storyboard!.instantiateViewController(withIdentifier: "NineEighteenViewController") as? NineEighteenViewController)
                NineEighteenApis.isBackground = false
                NineEighteenApis.message = "   type message here..."
                navigationController?.pushViewController(tabbar!, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @IBAction func okButton(_ sender: Any) {
        if(orderFrom == true){
            let HospitalitystoryBoard = UIStoryboard(name: "Hospitality", bundle: nil)
            let tabbar: UITabBarController? = HospitalitystoryBoard.instantiateViewController(withIdentifier: "HospitalityTabbarControllerViewController") as? HospitalityTabbarControllerViewController
            NineEighteenApis.message = "   type message here..."
            navigationController?.pushViewController(tabbar!, animated: true)
        }else{
             let MainstoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar: UITabBarController? = MainstoryBoard.instantiateViewController(withIdentifier: "NineEighteenViewController") as? NineEighteenViewController
            NineEighteenApis.message = "   type message here..."
            navigationController?.pushViewController(tabbar!, animated: true)
        }
    }
}
