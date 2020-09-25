//
//  EditViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 27/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class EditViewController: UIViewController {
    
   var cartDetails = [CartData]()
   var questionsResponse = [[String:Any]]()
   var isMember : Bool!
   var chargeId : String!
   var totalPrice : String!
   var tipValue : String!
   var email : String!
   var paymentStatus : Bool!
   var creditCardType : String!
   var doPaymentStatus : Bool!
   var orderId : String!
   var orderFrom : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.hidesBackButton = true
        if(isMember == true){
           submitOrder(totalPrice: totalPrice, tipValue: tipValue, mail: email)
        }else{
            changeOrderStatus(status: doPaymentStatus, orderId: orderId)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func submitOrder(totalPrice : String! , tipValue : String!,mail : String!) {
        var message = ""
        if(NineEighteenApis.message == "   type message here...") {
            message = ""
        } else {
            message = NineEighteenApis.message
        }
        for i in cartDetails {
            questionsResponse.append([
                "categoryName" : i.categoryName! ,
                "foodDesc" : i.foodDesc! ,
                "imageUrl" : i.imageUrl! ,
                "item_id" : i.itemId! ,
                "itemNote" : message,
                "name" : i.name! ,
                "price" : i.price!,
                "psteligible" : i.psteligible!,
                "quantity" : i.quantity!,
                "tax" : i.tax!,
            ])
        }
        let details = ["memberOrder" : isMember! , "user_id" : dataTask.LoginData().user_id! , "phone" : dataTask.LoginData().mobileNo! , "email" : mail! , "courseName" : "", "orderDetails" : questionsResponse , "holeNumber" : "0" ,"menuSectionId":cartDetails.first!.sectionId!,"cardholder" : NineEighteenApis.firstName + NineEighteenApis.lastName ,"cardType": creditCardType, "totalPrice" : Double(totalPrice)! , "tip" : Double(tipValue)! , "taxGST" : "0" , "taxPST" : "0" , "chargeId" : chargeId! , "courseId" : dataTask.LoginData().courseId!, "paymentStatus" : true] as [String : Any]

        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.submitOrder)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    if success == true && self.paymentStatus == true {
                        NineEighteenApis.isBackground = true
                        NineEighteenApis.message = "   type message here..."
                        CoreDataStack.shared.deleteContext()
                        self.questionsResponse.removeAll()
                        let orderKey = json["orderKey"] as? String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                        studentDVC.orderKey = orderKey
                        studentDVC.orderStatus = true
                        let parameters = ["isNew": true] as [String : Any]
                        NineEighteenSocketIOManager.sharedInstance.socket.emit("orderStatusChange", with:[parameters])
                        self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                    else if success == true && self.paymentStatus == false {
                        NineEighteenApis.isBackground = false
                        NineEighteenApis.message = "   type message here..."
                        self.questionsResponse.removeAll()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                        studentDVC.orderStatus = false
                        self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        NineEighteenApis.message = "   type message here..."
                        NineEighteenApis.isBackground = false
                        self.questionsResponse.removeAll()
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                        studentDVC.orderStatus = false
                        self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                }
            }
        }
    }

    
    private func changeOrderStatus(status : Bool!,orderId:String!) {
        let details = ["courseId" : dataTask.LoginData().courseId!,"paymentStatus" : status ,"chargeId":chargeId,"orderId" : orderId.components(separatedBy: "_")[1],"userId":dataTask.LoginData().user_id!] as [String : Any]
        print(details, orderId.components(separatedBy: "_")[1])
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.changePaymentStatus)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    print(json,"chnge order")
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                       let parameters = ["isNew": true] as [String : Any]
                       NineEighteenSocketIOManager.sharedInstance.socket.emit("orderStatusChange", with:[parameters])
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                        studentDVC.orderStatus = true
                        studentDVC.orderKey = orderId
                        self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                            studentDVC.orderStatus = false
                      self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                }
            }
        }
    }

}
