//
//  ChatViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 17/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var chatView: UITextView!
    var order = "0"
    var driverId = "0"
    var messages = [messagesData]()
    @IBOutlet weak var chatTableview: UITableView!
    @IBOutlet weak var chatScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NineEighteenSocketIOManager.sharedInstance.joinUser()
        chatView.layer.cornerRadius = 6
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        chatTableview.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        chatTableview.tableFooterView = UIView()
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
                   self.messages.append(messagesData(data: item))
                } else {
                }
            }
            DispatchQueue.main.async {
                self.chatTableview.reloadData()
                self.chatTableview.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
            }
        }
    }
    
    private func getMessages() {
        let details = ["order_id": order] as [String : Any]
        ModelParser.postApiServices(urlToExecute: URL(string: NineEighteenApis.getMessages)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let orderInfo = json["results"] as? [[String:Any]] else {return}
                    if orderInfo.count == 0 {}
                    else if orderInfo.count > 0 {
                        for i in orderInfo {
                            self.messages.append(messagesData(data: i))
                        }
                    }
                    else {
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    if !self.messages.isEmpty {
                        self.chatTableview.reloadData()
                        self.chatTableview.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK:- TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            chatView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (chatView.text == "      Type a message") {
            chatView.text = ""
            
        }
        chatView.becomeFirstResponder()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(chatView.text == "") {
            chatView.text = "      Type a message"
        }
        chatView.resignFirstResponder()
    }
    
    
    @IBAction func sendMessageButton(_ sender: Any) {
        if(chatView.text! ==  "      Type a message"){
            
        }else {
            if let message = chatView.text {
                if message.trimmingCharacters(in: .whitespaces) != "" {
                    let parameters = ["user_id": dataTask.LoginData().user_id!, "order_id": order ,"driver_id" : driverId, "sender" : 1 ,"message": message.trimmingCharacters(in: .whitespaces)] as [String : Any]
                    NineEighteenSocketIOManager.sharedInstance.socket.emit("sendUserMessage", with: [parameters])
                    self.messages.append(messagesData(data: parameters))
                    chatView.text! = ""
                    chatView.resignFirstResponder()
                    self.chatTableview.reloadData()
                    self.chatTableview.scrollToRow(at: IndexPath(row: (self.messages.count)-1, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}

extension ChatViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

