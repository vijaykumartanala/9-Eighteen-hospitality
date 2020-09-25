//
//  HospitalityOrderSummaryViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 13/04/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import BluesnapSDK


class HospitalityOrderSummaryViewController: UIViewController,isSelected,isQuestions {
    
    var cartDetails = [HospitalityItems]()
    var tax = 0.0
    var totalPrice = 0.0
    var toppingsTax = 0.0
    var toppingsPrice = 0.0
    var tipPercentage = 0.00
    var cartInfo: [String: String] = [:]
    var cartData : HospitalityItems? = nil
    var isShopper : Bool!
    var shopperId = ""
    fileprivate var bsToken : BSToken?
    fileprivate var sdkRequestBase: BSSdkRequestProtocol?
    var message = ""
    var orderId : String!
    var selectedData =  [[String:Any]]()
    var itemsCart =  [[String:Any]]()
    var pickuplocation : Int!
    var delveryquestions = [String:Any]()
    
    @IBOutlet weak var cartTotal: UILabel!
    @IBOutlet weak var taxesFees: UILabel!
    @IBOutlet weak var tipValue: UILabel!
    
    @IBOutlet weak var fButton: NineEighteenButton!
    @IBOutlet weak var tButton: NineEighteenButton!
    @IBOutlet weak var thButton: NineEighteenButton!
    @IBOutlet weak var zButton: UIButton!
    @IBOutlet weak var ordersummaryTableView: UITableView!
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var cartImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zButton.isHidden = true
        customData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        FSActivityIndicatorView.shared.dismiss()
    }
    
    //MARK:- CustomeMethods
    private func customData() {
        self.navigationItem.title = "ORDER SUMMARY"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        ordersummaryTableView.register(UINib(nibName: "HospitalityTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalityTableViewCell")
        pickupView.isHidden = true
        self.cartDetails = HospitalityCartData.fetchItemDetails()
        if((cartDetails.first?.delivery_type == 1) || (cartDetails.first?.delivery_type == 3)){
            pickupView.isHidden = false
        }
        cartImage.sd_setImage(with: URL(string: self.cartDetails.first!.bussiness_imageurl ?? ""), placeholderImage: UIImage(named: "resort"))
        NineEighteenApis.tip1 = cartDetails.first!.tip1
        NineEighteenApis.tip2 = cartDetails.first!.tip2
        NineEighteenApis.tip3 = cartDetails.first!.tip3
        self.ordersummaryTableView.reloadData()
        fButton.setTitle("\(Int( NineEighteenApis.tip1 * 100))" + " %", for: .normal)
        fButton.isSelected = true
        fButton.backgroundColor = UIColor(hexString: "#007AFF")
        fButton.setTitleColor(UIColor.white, for: .selected)
        tButton.setTitle("\(Int( NineEighteenApis.tip2 * 100))" + " %", for: .normal)
        thButton.setTitle("\(Int( NineEighteenApis.tip3 * 100))" + " %", for: .normal)
        calculations()
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice + toppingsPrice) * Double( NineEighteenApis.tip1)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax + toppingsTax)) + Double(totalPrice + toppingsPrice) + (Double(totalPrice + toppingsPrice) * Double(NineEighteenApis.tip1)))
    }
    
    func calculations() {
        if(fButton.isSelected){
            tipPercentage = NineEighteenApis.tip1
        }
        if(tButton.isSelected){
            tipPercentage = NineEighteenApis.tip2
        }
        if(thButton.isSelected){
            tipPercentage = NineEighteenApis.tip3
        }
        for i in cartDetails {
            tax += (i.tax! as NSString).doubleValue * (String(i.itemCount) as NSString).doubleValue
            for j in i.items!.allObjects as! [ItemsToppings]{
                if(j.is_selected == true){
                    toppingsTax += j.topping_tax
                    toppingsPrice += (Double(j.price) * Double(i.itemCount))
                }
            }
            totalPrice += (String(i.price) as NSString).doubleValue * (String(i.itemCount) as NSString).doubleValue
        }
        taxesFees.text! =  "$ " + String(format: "%.2f", tax + toppingsTax)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
        print(tipPercentage)
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax) + Double(totalPrice + toppingsPrice)) + (Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
    }
    
    
    @IBAction func fifteenButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip1
        fButton.isSelected = true
        tButton.isSelected = false
        thButton.isSelected = false
        if(fButton.isSelected){
            fButton.backgroundColor = UIColor(hexString: "#007AFF")
            fButton.setTitleColor(UIColor.white, for: .selected)
        }else{
            fButton.backgroundColor = UIColor(hexString: "#007AFF")
            fButton.setTitleColor(UIColor.white, for: .normal)
        }
        tButton.backgroundColor = UIColor(hexString: "#ffffff")
        tButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        thButton.backgroundColor = UIColor(hexString: "#ffffff")
        thButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax + toppingsTax)) + Double(totalPrice + toppingsPrice) + (Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
    }
    
    @IBAction func twentyButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip2
        fButton.isSelected = false
        tButton.isSelected = true
        thButton.isSelected = false
        if(tButton.isSelected){
            tButton.backgroundColor = UIColor(hexString: "#007AFF")
            tButton.setTitleColor(UIColor.white, for: .selected)
        }else{
            tButton.backgroundColor = UIColor(hexString: "#007AFF")
            tButton.setTitleColor(UIColor.white, for: .normal)
        }
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        thButton.backgroundColor = UIColor(hexString: "#ffffff")
        thButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        fButton.backgroundColor = UIColor(hexString: "#ffffff")
        fButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax + toppingsTax)) + Double(totalPrice + toppingsPrice) + (Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
    }
    
    @IBAction func thiryButton(_ sender: Any) {
        tipPercentage = NineEighteenApis.tip3
        fButton.isSelected = false
        tButton.isSelected = false
        thButton.isSelected = true
        if(thButton.isSelected){
            thButton.backgroundColor = UIColor(hexString: "#007AFF")
            thButton.setTitleColor(UIColor.white, for: .selected)
        }else{
            thButton.backgroundColor = UIColor(hexString: "#007AFF")
            thButton.setTitleColor(UIColor.white, for: .normal)
        }
        zButton.backgroundColor = UIColor(hexString: "#ffffff")
        zButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tButton.backgroundColor = UIColor(hexString: "#ffffff")
        tButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        fButton.backgroundColor = UIColor(hexString: "#ffffff")
        fButton.setTitleColor(UIColor(hexString: "#0C6E4C"), for: .normal)
        tipValue.text! = "$ " + String(format: "%.2f" ,(Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
        cartTotal.text! =  "$ " + String(format: "%.2f", (Double(tax + toppingsTax)) + Double(totalPrice + toppingsPrice) + (Double(totalPrice + toppingsPrice) * Double(tipPercentage)))
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationButton(_ sender: Any) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Hospitality", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "questionsViewController") as!  questionsViewController
        newViewcontroller.bussiness_id = self.cartDetails.first?.bussiness_id
        newViewcontroller.deliveryType = self.cartDetails.first?.delivery_type
        if(self.cartDetails.first?.delivery_type == 1){
            newViewcontroller.delegate = self
        }else if(self.cartDetails.first?.delivery_type == 3){
            newViewcontroller.delegate1 = self
            newViewcontroller.delveryquestions = delveryquestions
        }
        newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
            self.present(newViewcontroller, animated: true, completion:nil) })
    }
    
    //MARK:- Delegate Methods
    func is_selected(id: Int) {
        pickuplocation = id
    }
    
    func answers(a1: String, a2: String, a3: String, a4: String, a5: String) {
        delveryquestions = [ "question_1" : a1,
                             "question_2" : a2,
                             "question_3" : a3,
                             "question_4" : a4,
                             "question_5" : a4
        ]
    }
    //MARK:- Check out
    @IBAction func checkout(_ sender: Any) {
        if cartDetails.count == 0 {
            CoreDataStack.shared.deleteOrderedItems()
            self.navigationController?.popToRootViewController(animated: true)
            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "No Items in the cart", cancelButtonTitle: "OK", presentViewController: self)
        }
        else {
            if(cartDetails.first!.delivery_type == 1){
                if(pickuplocation == nil){
                    NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please select your location", cancelButtonTitle: "OK", presentViewController: self)
                }else {
                    generateHospitalityToken()
                }
            }else if (cartDetails.first!.delivery_type == 3){
                if(delveryquestions.count == 0){
                    NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please choose your location", cancelButtonTitle: "OK", presentViewController: self)
                }else {
                    if((self.delveryquestions["question_1"] as? String) == ""){
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Please choose your location", cancelButtonTitle: "OK", presentViewController: self)
                    }else{
                        generateHospitalityToken()
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        CoreDataStack.shared.deleteOrderedItems()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func generateHospitalityToken() {
        FSActivityIndicatorView.shared.show()
        let details = ["userId" : dataTask.LoginData().user_id!]
        ModelParser.postApiServices(urlToExecute: URL(string: HospitalityNineEighteenApis.shared.generateToken)!, parameters: details,methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    if let success = json["status"] as? Int {
                        if success == 200 {
                            let data = json["data"] as? [String:Any]
                            let token = data!["token"] as? String
                            self.isShopper = data!["isShopper"] as? Bool
                            self.shopperId = data!["shopperId"] as? String ?? ""
                            do {
                                self.bsToken = try BSToken(tokenStr: token)
                                self.initBluesnap()
                            }
                            catch {
                                FSActivityIndicatorView.shared.dismiss()
                            }
                        }
                        else {
                            FSActivityIndicatorView.shared.dismiss()
                            NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                        }
                    } else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                    
                }
            }
        }
    }
    
    private func initBluesnap() {
        do {
            try BlueSnapSDK.initBluesnap(
                bsToken: self.bsToken,
                generateTokenFunc: self.generateAndSetBsToken,
                initKount: true,
                fraudSessionId: nil,
                applePayMerchantIdentifier: "",
                merchantStoreCurrency: "CAD",
                completion: { error in
                    if error != nil {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong please try again later", cancelButtonTitle: "OK", presentViewController: self)
                    } else {
                        DispatchQueue.main.async {
                            FSActivityIndicatorView.shared.dismiss()
                            self.fillSdkRequest(isShopperRequirements: false, isSubscriptionCharge: false)
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
        let currency = "CAD"
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
                let orderDetails = submitHospitalityOrderDetails(email: billingDetails.email ?? "", creditCardType: ccType, paymentStatus: false, isMember:false, firstName: firstName, LastName: lastName, pfToken:  bsToken!.getTokenStr()!, cartType: ccType)
                print(orderDetails)
                ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.submitOrder)!, parameters: orderDetails, methodType: "POST", accessToken: false) { (response,error) in
                    DispatchQueue.main.async {
                        if let unwrappedError = error {
                            print(unwrappedError.localizedDescription)
                        }
                        if let json = response {
                            guard let success = json["status"] as? Int else {return}
                            if success == 200 {
                                FSActivityIndicatorView.shared.dismiss()
                                let data = json["data"] as? [String:Any]
                                self.orderId = data!["orderKey"] as? String
                                if(self.cartDetails.first!.delivery_type == 2){
                                    NineEighteenApis.isBackground = true
                                }
                                let parameters = ["isNew": true,"to":"kitchen"] as [String : Any]
                                HospitalitySocketIOManager.hospitalitySharedInstance.hospitalitySocket.emit("orderStatusChange", with:[parameters])
                                NineEighteenApis.message = "   type message here..."
                                CoreDataStack.shared.deleteOrderedItems()
                                self.selectedData.removeAll()
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                                studentDVC.orderStatus = true
                                studentDVC.orderFrom = true
                                studentDVC.delivery_type = Int(self.cartDetails.first!.delivery_type)
                                studentDVC.orderKey = self.orderId
                                self.navigationController!.pushViewController(studentDVC, animated: true)
                            }
                            else {
                                FSActivityIndicatorView.shared.dismiss()
                                NineEighteenApis.message = "   type message here..."
                                NineEighteenApis.isBackground = false
                                self.selectedData.removeAll()
                                CoreDataStack.shared.deleteOrderedItems()
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                                studentDVC.orderStatus = false
                                studentDVC.orderFrom = true
                                self.navigationController!.pushViewController(studentDVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK:- Submit order
    internal func submitHospitalityOrderDetails(email:String!,creditCardType:String!,paymentStatus:Bool!,isMember:Bool!,firstName : String! , LastName : String!,pfToken:String!,cartType:String!) -> [String:Any] {
        if(NineEighteenApis.message == "   type message here...") {
            message = ""
        } else {
            message = NineEighteenApis.message
        }
        for i in cartDetails {
            for j in i.items!.allObjects as! [ItemsToppings] {
                if(i.id == j.item_id){
                    if(j.is_selected == true){
                        itemsCart.append([
                            "id" : j.id,
                            "item_id" :  j.item_id,
                            "price" : j.price,
                            "name" : j.name!,
                            "is_selected" : j.is_selected,
                        ])
                    }
                }
            }
            selectedData.append([
                "price" : i.price,
                "quantity" : i.itemCount,
                "item_id": i.id,
                "toppings": itemsCart
            ])
            itemsCart.removeAll()
        }
        let details = ["memberOrder" : isMember! ,
                       "userId" : dataTask.LoginData().user_id!,
                       "pfToken":pfToken!,
                       "amount" : Double(self.cartTotal.text!.dropFirst(2))!,
                       "firstName":firstName!,
                       "lastName":LastName!,
                       "currency":"CAD",
                       "resortId": dataTask.HospitalityData().hospitalitycourseId!,
                       "businessId":cartDetails.first!.bussiness_id,
                       "cardTransactionType":"AUTH_CAPTURE",
                       "email" : email! ,
                       "totalPrice":Double(self.cartTotal.text!.dropFirst(2))!,
                       "tip" : Double(self.tipValue.text!.dropFirst(2))! ,
                       "cardType":cartType!,
                       "device":"from iOS",
                       "delivery_note":message,
                       "delivery_type":cartDetails.first!.delivery_type ,
                       "pickup_location_id" : pickuplocation,
                       "deliveryQuestions" : delveryquestions,
                       "address":"something",
                       "isShopper":isShopper!,
                       "shopperId":shopperId,
                       "orderDetails" : selectedData ,
                       "cardholder" : firstName! + LastName! ,
                       "paymentStatus" : paymentStatus!] as [String : Any]
        
        return details
    }
}



extension HospitalityOrderSummaryViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalityTableViewCell") as! HospitalityTableViewCell
        cell.detailcartItem = self
        cell.cartCardView.backgroundColor = UIColor.init(hexString: "EBEBEB")
        cell.updateInfoHospitality(feed: cartDetails[indexPath.row])
        cell.itemName.text! = cartDetails[indexPath.row].name!
        cell.itemDesc.text! = cartDetails[indexPath.row].item_description!
        cell.itemCount.text! = String(cartDetails[indexPath.row].itemCount)
        if((cartDetails[indexPath.row].items?.allObjects.count)! > 0){
            var totalPrice = 0
            cell.toppingButton.tag = Int(cartDetails[indexPath.row].id)
            for i in cartDetails[indexPath.row].items!.allObjects as! [ItemsToppings] {
                if(i.is_selected == true){
                    totalPrice += Int(i.price)
                }
            }
            cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price) * Double(cartDetails[indexPath.row].itemCount)) + Double(totalPrice) * Double(cartDetails[indexPath.row].itemCount))
        }
        else{
            cell.toppingButton.isHidden = true
            cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(cartDetails[indexPath.row].price) * Double(cartDetails[indexPath.row].itemCount)))
        }
        cell.addButton.tag =  Int(cartDetails[indexPath.row].id)
        cell.minusButton.tag = Int(cartDetails[indexPath.row].id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
