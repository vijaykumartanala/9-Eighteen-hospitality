//
//  HospitalitySocketIOManager.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 21/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import SocketIO

class HospitalitySocketIOManager: NSObject {
    
    static let hospitalitySharedInstance = HospitalitySocketIOManager()
    var hospitalitySocket: SocketIOClient!
    var hospitalityManager: SocketManager!
    var window: UIWindow?
    
    private override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        let urlString = String(format: "http://hospitality.9-eighteen.com:8888")
        hospitalityManager = SocketManager(socketURL: URL(string: urlString)!,config: [.log(false),.reconnects(true)])
        hospitalitySocket = hospitalityManager.socket(forNamespace: "/")
        hospitalityAddLisiners()
        hospitalityJoinUser()
    }
    
    internal func hospitalityJoinUser() {
        self.hospitalitySocket.emit("joinUser",dataTask.LoginData().user_id!)
    }
    
    internal func hospitalityAddLisiners() {
        hospitalitySocket.on(clientEvent: .connect) {data, ack in
            print("socket connected vijay \(data)")
            self.hospitalityJoinUser()
        }
        hospitalitySocket.on(clientEvent: .error) {data, ack in
            print("socket error \(data)")
        }
        hospitalitySocket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnect: \(data)")
        }
        hospitalitySocket.on("receiveDriverMessage", callback: { (responseArray, ack) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil, userInfo: ["newChat": responseArray])
        })
    }
    
    func hospitalityEstablishConnection() {
        hospitalitySocket.connect()
    }
    
    func hospitalityCloseConnection() {
        hospitalitySocket.disconnect()
    }
}
