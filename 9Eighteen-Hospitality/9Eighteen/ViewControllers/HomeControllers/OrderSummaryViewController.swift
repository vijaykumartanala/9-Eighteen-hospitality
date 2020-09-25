//
//  OrderSummaryViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 12/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData
import BluesnapSDK

class OrderSummaryViewController: UIViewController {
    
    @IBOutlet weak var orderTableview: UITableView!
    @IBOutlet weak var cartTotal: UILabel!
    @IBOutlet weak var taxesFees: UILabel!
    @IBOutlet weak var tipValue: UILabel!
    
    @IBOutlet weak var fButton: NineEighteenButton!
    @IBOutlet weak var tButton: NineEighteenButton!
    @IBOutlet weak var thButton: NineEighteenButton!
    @IBOutlet weak var zButton: UIButton!
    
    var cartDetails = [CartData]()
    var tax = 0.0
    var totalPrice = 0.0
    var tipPercentage = 0.00
    var cartInfo: [String: String] = [:]
    var cartData : CartData? = nil
    var isShopper : Bool!
    var shopperId = ""
    fileprivate var bsToken : BSToken?
    fileprivate var sdkRequestBase: BSSdkRequestProtocol?
    var message = ""
    var questionsResponse = [[String:Any]]()
    var orderId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ORDER SUMMARY"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        orderTableview.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        self.cartDetails = CartData.fetchCartDetails()
        calculations()
        self.orderTableview.reloadData()
        fButton.setTitle("\(Int(NineEighteenApis.tip1 * 100))" + " %", for: .normal)
        tButton.setTitle("\(Int(NineEighteenApis.tip2 * 100))" + " %", for: .normal)
        thButton.setTitle("\(Int(NineEighteenApis.tip3 * 100))" + " %", for: .normal)
        zButton.setTitle("\(Int(NineEighteenApis.tip4 * 100))" + " %", for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(NineEighteenApis.tip1)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax)) + Double(totalPrice) + (Double(totalPrice) * Double(NineEighteenApis.tip1)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
    }
    
    //MARK:- CustomeMethods
    func calculations() {
        for i in cartDetails {
            tax += (i.tax! as NSString).doubleValue * (i.quantity! as NSString).doubleValue
            totalPrice += (i.price! as NSString).doubleValue * (i.quantity! as NSString).doubleValue
        }
        taxesFees.text! =  "$ " + String(format: "%.2f", tax)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax) + Double(totalPrice)) + (Double(totalPrice) * Double(tipPercentage)))
    }
    
    @IBAction func fifteenButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip1
        fButton.backgroundColor = UIColor(hexString: "#33AA7E")
        fButton.setTitleColor(UIColor.white, for: .normal)
        tButton.backgroundColor = UIColor(hexString: "#ffffff")
        tButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        thButton.backgroundColor = UIColor(hexString: "#ffffff")
        thButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax)) + Double(totalPrice) + (Double(totalPrice) * Double(tipPercentage)))
    }
    
    @IBAction func twentyButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip2
        tButton.backgroundColor = UIColor(hexString: "#33AA7E")
        tButton.setTitleColor(UIColor.white, for: .normal)
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        thButton.backgroundColor = UIColor(hexString: "#ffffff")
        thButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        fButton.backgroundColor = UIColor(hexString: "#ffffff")
        fButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax)) + Double(totalPrice) + (Double(totalPrice) * Double(tipPercentage)))
    }
    
    @IBAction func thiryButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip3
        thButton.backgroundColor = UIColor(hexString: "#33AA7E")
        thButton.setTitleColor(UIColor.white, for: .normal)
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tButton.backgroundColor = UIColor(hexString: "#ffffff")
        tButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        fButton.backgroundColor = UIColor(hexString: "#ffffff")
        fButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax)) + Double(totalPrice) + (Double(totalPrice) * Double(tipPercentage)))
    }
    
    @IBAction func zbutton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip4
        zButton.backgroundColor = UIColor(hexString: "#33AA7E")
        zButton.setTitleColor(UIColor.white, for: .normal)
        thButton.backgroundColor = UIColor(hexString: "#ffffff")
        thButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tButton.backgroundColor = UIColor(hexString: "#ffffff")
        tButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        fButton.backgroundColor = UIColor(hexString: "#ffffff")
        fButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax)) +  Double(totalPrice) + (Double(totalPrice) * Double(tipPercentage)))
    }
    
    @IBAction func clear(_ sender: Any) {
        CoreDataStack.shared.deleteContext()
        tax = 0.0
        totalPrice = 0.0
        tipPercentage = 0.0
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func checkout(_ sender: Any) {
        if cartDetails.count == 0 {
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "No Items in the cart", cancelButtonTitle: "OK", presentViewController: self)
            self.navigationController?.popToRootViewController(animated: true)
        }
        else if dataTask.LoginData().member == 2 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            studentDVC.isMember = true
            studentDVC.chargeId = ""
            studentDVC.totalPrice = "\(cartTotal.text!.dropFirst(2))"
            studentDVC.tipValue = "\(tipValue.text!.dropFirst(2))"
            studentDVC.email = ""
            studentDVC.cartDetails = self.cartDetails
            studentDVC.paymentStatus = true
            studentDVC.creditCardType = ""
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }
        else {
            generateToken()
        }
    }
    
    private func generateToken() {
        FSActivityIndicatorView.shared.show()
        let details = ["userId" : dataTask.LoginData().user_id!]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.token)!, parameters: details,methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        FSActivityIndicatorView.shared.dismiss()
                        guard let token = json["response"] as? String else {return}
                        self.isShopper = json["isShopper"] as? Bool
                        self.shopperId = json["shopperId"] as? String ?? ""
                        do {
                            self.bsToken = try BSToken(tokenStr: token)
                            self.initBluesnap()
                        }
                        catch {
                            FSActivityIndicatorView.shared.dismiss()
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
    private func initBluesnap() {
        FSActivityIndicatorView.shared.show()
        do {
            try BlueSnapSDK.initBluesnap(
                bsToken: self.bsToken,
                generateTokenFunc: self.generateAndSetBsToken,
                initKount: true,
                fraudSessionId: nil,
                applePayMerchantIdentifier: "",
                merchantStoreCurrency: NineEighteenApis.currencyCode,
                completion: { error in
                    if error != nil {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong please try again later", cancelButtonTitle: "OK", presentViewController: self)
                    } else {
                        DispatchQueue.main.async {
                            // open the purchase screen
                            self.fillSdkRequest(isShopperRequirements: false, isSubscriptionCharge: false)
                            FSActivityIndicatorView.shared.dismiss()
                            do {
                                try BlueSnapSDK.showCheckoutScreen(
                                    inNavigationController: self.navigationController,
                                    animated: true,
                                    sdkRequest: self.sdkRequestBase as? BSSdkRequest)
                            } catch {
                                FSActivityIndicatorView.shared.dismiss()
                                NSLog("Unexpected error: \(error).")
                            }
                        }
                    }
            })
            
        } catch {
            FSActivityIndicatorView.shared.dismiss()
            NSLog("Unexpected error: \(error).")
        }
    }
    
    func generateAndSetBsToken(completion: @escaping (_ token: BSToken?, _ error: BSErrors?)->Void) {
        do {
            try BlueSnapSDK.setBsToken(bsToken: self.bsToken)
            DispatchQueue.main.async {
                
            }
            
        } catch {
            NSLog("Unexpected error: \(error).")
        }
    }
    
    private func fillSdkRequest(isShopperRequirements: Bool, isSubscriptionCharge: Bool) {
        let amount = Double(cartTotal.text!.dropFirst(2))
        let taxAmount = Double(0.0)
        let currency = NineEighteenApis.currencyCode
        let priceDetails = (!isShopperRequirements) ? BSPriceDetails(amount: amount, taxAmount: taxAmount, currency: currency) : nil
        sdkRequestBase = BSSdkRequest(withEmail: true, withShipping: false, fullBilling: false, priceDetails: priceDetails, billingDetails: nil, shippingDetails: nil, purchaseFunc: self.completePurchase, updateTaxFunc: self.updateTax)
        sdkRequestBase?.allowCurrencyChange = false
        sdkRequestBase?.hideStoreCardSwitch = true
        NSLog("sdkRequestBase store Card = \(String(describing: sdkRequestBase?.hideStoreCardSwitch))")
        
    }
    
    func updateTax(_ shippingCountry: String,
                   _ shippingState: String?,
                   _ priceDetails: BSPriceDetails) -> Void {
        var taxPercent: NSNumber = 0
        if shippingCountry.uppercased() == "US" {
            taxPercent = 5
            if let state = shippingState {
                if state == "NY" {
                    taxPercent = 8
                }
            }
        } else if shippingCountry.uppercased() == "CA" {
            taxPercent = 1
        }
        let newTax: NSNumber = priceDetails.amount.doubleValue * taxPercent.doubleValue / 100.0 as NSNumber
        NSLog("Changing tax amount from \(String(describing: priceDetails.taxAmount)) to \(newTax)")
        priceDetails.taxAmount = newTax
    }
    
    private func completePurchase(purchaseDetails: BSBaseSdkResult!) {
        if let purchaseDetails = purchaseDetails as? BSCcSdkResult {
            if let billingDetails = purchaseDetails.getBillingDetails() {
                let firstName    = billingDetails.getSplitName()?.firstName ?? ""
                let lastName = billingDetails.getSplitName()?.lastName ?? ""
                let ccType = purchaseDetails.creditCard.ccType ?? ""
                FSActivityIndicatorView.shared.show()
                let orderDetails = submitOrderDetails(email: billingDetails.email ?? "", creditCardType: ccType, paymentStatus: false, isMember:false, firstName: firstName, LastName: lastName)
                ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.submitOrder)!, parameters: orderDetails, methodType: "POST", accessToken: false) { (response,error) in
                    DispatchQueue.main.async {
                        if let unwrappedError = error {
                            print(unwrappedError.localizedDescription)
                        }
                        if let json = response {
                            guard let success = json["success"] as? Bool else {return}
                            if success == true {
                                FSActivityIndicatorView.shared.dismiss()
                                self.orderId = json["orderKey"] as? String
                                NineEighteenApis.isBackground = true
                                NineEighteenApis.message = "   type message here..."
                                CoreDataStack.shared.deleteContext()
                                self.questionsResponse.removeAll()
                                self.doPayment(amount: String(purchaseDetails.getAmount()), firstName: firstName, country: billingDetails.country ?? "", zip: billingDetails.zip ?? "", fraudSessionId:purchaseDetails.getFraudSessionId() ?? "", lastName: lastName, email: billingDetails.email ?? "", creditCardType: ccType)
                            }
                            else {
                                FSActivityIndicatorView.shared.dismiss()
                                NineEighteenApis.message = "   type message here..."
                                NineEighteenApis.isBackground = false
                                self.questionsResponse.removeAll()
                                CoreDataStack.shared.deleteContext()
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
    }
    
    private func doPayment(amount : String! , firstName : String? ,country:String!,zip:String!, fraudSessionId:String!,lastName : String?,email : String!,creditCardType:String!) {
        FSActivityIndicatorView.shared.show()
        let details = ["pfToken" : bsToken!.getTokenStr()!,"amount" : amount! , "firstName" : firstName ?? "", "lastName" : lastName ?? "" , "fraudSessionId":fraudSessionId!,"country":country!,"zip":zip!,"courseId" : dataTask.LoginData().courseId!, "currency" : NineEighteenApis.currencyCode , "cardTransactionType" : "AUTH_CAPTURE" , "email" : email!, "isShopper" : isShopper! , "shopperId" :shopperId , "userId" : dataTask.LoginData().user_id!] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.doPayment)!, parameters: details,methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        NineEighteenApis.firstName = firstName ?? ""
                        NineEighteenApis.lastName = lastName ?? ""
                        FSActivityIndicatorView.shared.dismiss()
                        self.questionsResponse.removeAll()
                        CoreDataStack.shared.deleteContext()
                        let chargeId = json["response"] as? String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
                        studentDVC.doPaymentStatus = true
                        studentDVC.orderId = self.orderId
                        studentDVC.chargeId = chargeId
                        self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                    else if success == false {
                       FSActivityIndicatorView.shared.dismiss()
                       NineEighteenApis.message = "   type message here..."
                       NineEighteenApis.isBackground = false
                       self.questionsResponse.removeAll()
                       CoreDataStack.shared.deleteContext()
                       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                      let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                          studentDVC.orderStatus = false
                      self.navigationController!.pushViewController(studentDVC, animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
            }
        }
    }
    
//MARK:- Submit order
    internal func submitOrderDetails(email:String!,creditCardType:String!,paymentStatus:Bool!,isMember:Bool!,firstName : String! , LastName : String!) -> [String:Any] {
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
        let details = ["memberOrder" : isMember! , "user_id" : dataTask.LoginData().user_id! , "phone" : dataTask.LoginData().mobileNo! , "email" : email! , "courseName" : "", "orderDetails" : questionsResponse , "holeNumber" : "0" ,"menuSectionId":cartDetails.first!.sectionId!,"cardholder" : firstName + LastName ,"cardType": creditCardType, "totalPrice" : Double(self.cartTotal.text!.dropFirst(2))! , "tip" : Double(self.tipValue.text!.dropFirst(2))! , "taxGST" : "0" , "taxPST" : "0" , "chargeId" : "" ,"device":"from iOS", "courseId" : dataTask.LoginData().courseId!, "paymentStatus" : paymentStatus!] as [String : Any]
        
        return details
    }
}

extension OrderSummaryViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        cell.detailItems = self
        cell.updateInfo(feed: cartDetails[indexPath.row])
        cell.itemName.text! = cartDetails[indexPath.row].name!
        cell.price.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price!)! * Double(cartDetails[indexPath.row].quantity!)!))
        cell.itemDetail.text! = cartDetails[indexPath.row].foodDesc!
        cell.itemCount.text! =  cartDetails[indexPath.row].quantity!
        cell.addButton.tag =  Int(cartDetails[indexPath.row].itemId!)!
        cell.minusButton.tag = Int(cartDetails[indexPath.row].itemId!)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

