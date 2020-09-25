//
//  NineEighteenSocketIOManager.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 17/12/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import SocketIO

class NineEighteenSocketIOManager: NSObject {
    
    static let sharedInstance = NineEighteenSocketIOManager()
    var socket: SocketIOClient!
    var manager: SocketManager!
    var window: UIWindow?
    
    private override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        let urlString = String(format: "http://qa.9-eighteen.com:6501")
        manager = SocketManager(socketURL: URL(string: urlString)!,config: [.log(false),.reconnects(true)])
        socket = manager.socket(forNamespace: "/")
        addLisiners()
        joinUser()
    }
    
    internal func joinUser() {
        self.socket.emit("joinUser", dataTask.LoginData().user_id!)
    }
    
    internal func addLisiners() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected vijay \(data)")
            self.joinUser()
        }
        socket.on(clientEvent: .error) {data, ack in
            print("socket error \(data)")
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnect: \(data)")
        }
        socket.on("receiveDriverMessage", callback: { (responseArray, ack) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil, userInfo: ["newChat": responseArray])
        })
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func createLogin(vc:UIViewController,message:String) {
        let alert = UIAlertController(title: "Sign up for 9-Eighteen", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navVc = UINavigationController(rootViewController: initialViewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVc
            self.window?.makeKeyAndVisible()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}
