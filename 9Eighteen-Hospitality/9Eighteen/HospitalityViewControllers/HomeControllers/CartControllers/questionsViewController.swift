//
//  questionsViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 20/07/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

protocol isSelected {
    func is_selected(id : Int)
}
protocol isQuestions {
    func answers(a1 : String,a2 : String,a3 : String,a4 : String,a5 : String)
}

class questionsViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var q1: UITextField!
    @IBOutlet weak var q2: UITextField!
    @IBOutlet weak var q3: UITextField!
    @IBOutlet weak var q4: UITextField!
    @IBOutlet weak var q5: UITextField!
    @IBOutlet weak var view1: CardView!
    @IBOutlet weak var view2: CardView!
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var saveButton: NineEighteenButton!
    
    var delveryquestions = [String:Any]()
    var bussiness_id : Int16?
    var deliveryType : Int16?
    var fieldArray = [AnyObject]()
    var question = [questions]()
    var location = [locations]()
    var delegate : isSelected!
    var delegate1 : isQuestions!
    var order = [hospitalityorderData]()
    var fromHistory :Bool!
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        q1.isHidden = true
        q2.isHidden = true
        q3.isHidden = true
        q4.isHidden = true
        q5.isHidden = true
        label.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        })
        if(fromHistory == true){
            saveButton.isHidden = true
            if(order.first!.delivery_type == 3){
                view2.isHidden = true
                view1.isHidden = false
                if(order.first?.que1 != ""){
                    q1.isHidden = false
                    q1.isUserInteractionEnabled = false
                    q1.text! = order.first!.ans1
                    q1.placeholder = order.first?.que1
                }
                if(order.first?.que2 != ""){
                    q2.isHidden = false
                    q2.isUserInteractionEnabled = false
                    q2.text! = order.first!.ans2
                    q2.placeholder = order.first?.que2
                }
                if(order.first?.que3 != ""){
                    q3.isHidden = false
                    q2.isUserInteractionEnabled = false
                    q3.text! = order.first!.ans3
                    q3.placeholder = order.first?.que3
                }
                if(order.first?.que4 != ""){
                    q4.isHidden = false
                    q2.isUserInteractionEnabled = false
                    q4.text! = order.first!.ans4
                    q4.placeholder = order.first?.que4
                }
                if(order.first?.que5 != ""){
                    q5.isHidden = false
                    q2.isUserInteractionEnabled = false
                    q5.text! = order.first!.ans5
                    q5.placeholder = order.first?.que5
                }
            }
            if(order.first!.delivery_type == 1){
                view2.isHidden = false
                view1.isHidden = false
                locationsTableView.delegate = self
                locationsTableView.dataSource = self
                locationsTableView.register(UINib(nibName: "pickupTableViewCell", bundle: nil), forCellReuseIdentifier: "pickupTableViewCell")
            }
        }else{
            if(deliveryType == 1){
                view2.isHidden = false
                view1.isHidden = false
                locationsTableView.delegate = self
                locationsTableView.dataSource = self
                locationsTableView.register(UINib(nibName: "pickupTableViewCell", bundle: nil), forCellReuseIdentifier: "pickupTableViewCell")
                getPickup()
            }else{
                view2.isHidden = true
                view1.isHidden = false
                getQuestions()
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        delegate1.answers(a1: q1.text!, a2: q2.text!, a3: q3.text!, a4: q4.text!, a5: q5.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getPickup() {
        bgLabel(message: "Loading....", question: false)
        let details = ["business_id": bussiness_id]
        let url = "\(HospitalityNineEighteenApis.baseUrl)" + "getPickupLocations"
        ModelParser.postApiServices(urlToExecute: URL(string:url)!, parameters: details as [String : Any], methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    self.bgLabel(message: "something went wrong", question: false)
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    self.label.isHidden = true
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        if let data = json["data"] as? [[String:Any]]{
                            for i in data{
                                self.location.append(locations(data: i))
                            }
                        }
                    }
                    else {
                        self.bgLabel(message: "something went wrong", question: false)
                    }
                }
                DispatchQueue.main.async {
                    self.locationsTableView.reloadData()
                }
            }
        }
    }
    
    private func getQuestions() {
        bgLabel(message: "Loading.....", question: true)
        let details = ["business_id": bussiness_id]
        let url = "\(HospitalityNineEighteenApis.baseUrl)" + "getDeliveryQuestions"
        ModelParser.postApiServices(urlToExecute: URL(string:url)!, parameters: details as [String : Any], methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    self.bgLabel(message: "something went wrong", question: true)
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        self.label.isHidden = true
                        if let data = json["data"] as? [[String:Any]]{
                            for i in data{
                                self.question.append(questions(data: i))
                            }
                        }
                        if(self.question.first?.question_1 != ""){
                            self.q1.isHidden = false
                            self.q1.placeholder = self.question.first?.question_1
                        }
                        if(self.question.first?.question_2 != ""){
                            self.q2.isHidden = false
                            self.q2.placeholder = self.question.first?.question_2
                        }
                        if(self.question.first?.question_3 != ""){
                            self.q3.isHidden = false
                            self.q3.placeholder = self.question.first?.question_3
                        }
                        if(self.question.first?.question_4 != ""){
                            self.q4.isHidden = false
                            self.q4.placeholder = self.question.first?.question_4
                        }
                        if(self.question.first?.question_5 != ""){
                            self.q5.isHidden = false
                            self.q5.placeholder = self.question.first?.question_5
                        }
                        if(self.delveryquestions.count > 0){
                            self.q1.text! = (self.delveryquestions["question_1"] as? String)!
                            self.q2.text! = (self.delveryquestions["question_2"] as? String)!
                            self.q3.text! = (self.delveryquestions["question_3"] as? String)!
                            self.q4.text! = (self.delveryquestions["question_4"] as? String)!
                            self.q5.text! = (self.delveryquestions["question_5"] as? String)!
                        }
                    }
                }
                else {
                    self.bgLabel(message: "something went wrong", question: true)
                }
            }
            
        }
    }
       
    private func bgLabel(message : String!,question:Bool!) {
           label.isHidden = false
           label.lineBreakMode = .byWordWrapping
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = message
           label.textColor = UIColor.darkGray
           label.font = UIFont(name: "Poppins-Regular", size: 18.0)
           label.numberOfLines = 0
            if(question){
                self.view1.addSubview(label)
                label.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                label.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
            }else{
                self.view2.addSubview(label)
                label.widthAnchor.constraint(equalTo: view2.widthAnchor).isActive = true
                label.centerXAnchor.constraint(equalTo: view2.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view2.centerYAnchor).isActive = true
            }
           
       }
}

extension questionsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(fromHistory == true){
            return 1
        }else{
            return location.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickupTableViewCell") as! pickupTableViewCell
        if(fromHistory == true){
            cell.address.text! = order.first!.pickup_location["address"] as? String ?? ""
            cell.locationName.text! = order.first!.pickup_location["location_name"] as? String ?? ""
        }else{
         cell.address.text! = location[indexPath.row].address!
         cell.locationName.text! = location[indexPath.row].location_name!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = locationsTableView.cellForRow(at: indexPath) as! pickupTableViewCell
        if(fromHistory == true){
            self.dismiss(animated: true, completion: nil)
        }else{
            cell.pickupCardView.backgroundColor = UIColor.init(hexString: "#41D49D")
            cell.address.textColor! = UIColor.white
            cell.locationName.textColor! = UIColor.white
            self.delegate.is_selected(id: location[indexPath.row].id!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = locationsTableView.cellForRow(at: indexPath) as! pickupTableViewCell
        cell.pickupCardView.backgroundColor = UIColor.init(hexString: "#41D49D")
        cell.address.textColor! = UIColor.white
        cell.locationName.textColor! = UIColor.white
    }
    
}
