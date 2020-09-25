//
//  HospitalityChatViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 21/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit


class HospitalityChatViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var chatScroll: UIScrollView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var message: UITextView!
    
    var order = "0"
    var driverId = "0"
    var bussinessId = "0"
    var messages = [hospitalityMessagesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HospitalitySocketIOManager.hospitalitySharedInstance.hospitalityJoinUser()
        message.layer.cornerRadius = 6
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        chatTableView.tableFooterView = UIView()
        getMessages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    
    @objc private func fetchNewMessages(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let newList = userInfo["newChat"] as! [[String:Any]]
            for item in newList {
                if(order == item["order_id"] as? String){
                    self.messages.append(hospitalityMessagesData(data: item))
                } else {
                }
            }
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
            }
        }
    }
    
    private func getMessages() {
        let details = ["order_id": order] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: HospitalityNineEighteenApis.shared.getMessages)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let orderInfo = json["data"] as? [String:Any] else {return}
                    if orderInfo.count == 0 {}
                    else if orderInfo.count > 0 {
                        if let results = orderInfo["results"] as? [[String:Any]]{
                            for i in results {
                                self.messages.append(hospitalityMessagesData(data: i))
                            }
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    if !self.messages.isEmpty {
                        self.chatTableView.reloadData()
                        self.chatTableView.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK:- TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            message.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (message.text == "      Type a message") {
            message.text = ""
            
        }
        message.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(message.text == "") {
            message.text = "      Type a message"
        }
        message.resignFirstResponder()
    }
    
    
    //MARK:- Message send Methods
    @IBAction func sendButton(_ sender: Any) {
        if(message.text! ==  "      Type a message"){
            
        }else {
            if let sendmessage = message.text {
                if sendmessage.trimmingCharacters(in: .whitespaces) != "" {
                    let parameters = ["user_id": dataTask.LoginData().user_id!, "order_id": order ,"business_id":bussinessId,"driver_id" : driverId, "sender" : 1 ,"message": sendmessage.trimmingCharacters(in: .whitespaces)] as [String : Any]
                    print(parameters)
                HospitalitySocketIOManager.hospitalitySharedInstance.hospitalitySocket.emit("sendUserMessage", with: [parameters])
                    self.messages.append(hospitalityMessagesData(data: parameters))
                    message.text! = ""
                    message.resignFirstResponder()
                    self.chatTableView.reloadData()
                    self.chatTableView.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}

extension HospitalityChatViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0 {
            self.chatTableView.setEmptyMessage("No Messages found")
        } else {
            self.chatTableView.restore()
        }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        cell.name.text! = ""
        if messages[indexPath.row].sender == 1 {
            cell.chatView.backgroundColor = UIColor.init(hexString: "#C1F3D2")
            cell.chatStackView.alignment = .trailing
            cell.message.text! = messages[indexPath.row].message
        } else {
            cell.chatView.backgroundColor = UIColor.init(hexString: "#D7E3F0")
            cell.chatStackView.alignment = .leading
            cell.message.text! = messages[indexPath.row].message
        }
        return cell
    }
}

