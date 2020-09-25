//
//  AppDelegate.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CoreLocation
import Firebase
import Messages
import UserNotifications
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var timerBack  = Timer()
    var locationManager = CLLocationManager()
    var lat  = ""
    var long = ""
    let notificationCenter = UNUserNotificationCenter.current()
    var badgeCount = 0
    let notificationcenter = NotificationCenter.default
    static var count = 0
    let gcmMessageIDKey = "gcm.message_id"
    let siren = Siren.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        doBackgroundTask()
        AppDelegate.count = 0
        autoLogin()
        siren.alertType = .force
        siren.checkVersion(checkType: .immediately)
        //      siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        hospitalityAutoLogin()
        UINavigationBar.appearance().barStyle = .blackOpaque
        let navBackgroundImage:UIImage! = UIImage()
        UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, for: .default)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = true
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: UIControlState.highlighted)
        if let notificationCount = UserDefaults.standard.object(forKey: "badgeCount") as? Int {
            dataTask.badgeCount = notificationCount
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            notificationCenter.delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK:- Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",$1)})
        Messaging.messaging().apnsToken = deviceToken
        UserDefaults.standard.set(tokenString, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("hello" , userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let pnEnable = UserDefaults.standard.bool(forKey: "pn")
        if pnEnable {
            
        } else {
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lat = String(location.coordinate.latitude)
            long = String(location.coordinate.longitude)
        }
    }
    
    func doBackgroundTask() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.beginBackgroundUpdateTask()
            self.timerBack = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AppDelegate.displayAlert), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timerBack, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
            self.endBackgroundUpdateTask()
        }
    }
    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    @objc func displayAlert() {
        if NineEighteenApis.isBackground == true {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 10
                locationManager.allowsBackgroundLocationUpdates = true
            }
            let details = ["user_id": dataTask.LoginData().user_id! , "latitude" : "\(lat)" , "longitude" : "\(long)"]
            let selectedApp = UserDefaults.standard.bool(forKey: "isFrom")
            if(selectedApp){
                ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.locationUpdate)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
                    DispatchQueue.main.async {
                        if let unwrappedError = error {
                            FSActivityIndicatorView.shared.dismiss()
                            print(unwrappedError.localizedDescription)
                        }
                        if let json = response {
                            guard let success = json["status"] as? Int else {return}
                            if success == 200 {
                            }
                            else {
                                NineEighteenApis.isBackground = false
                                self.endBackgroundUpdateTask()
                            }
                        }
                    }
                }
            }
            else{
                ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.locationUpdateApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
                    DispatchQueue.main.async {
                        if let unwrappedError = error {
                            FSActivityIndicatorView.shared.dismiss()
                            print(unwrappedError.localizedDescription)
                        }
                        if let json = response {
                            guard let success = json["success"] as? Bool else {return}
                            if success == true {
                            }
                            else {
                                NineEighteenApis.isBackground = false
                                self.endBackgroundUpdateTask()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        siren.checkVersion(checkType: .daily)
        //      NineEighteenSocketIOManager.sharedInstance.establishConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        siren.checkVersion(checkType: .immediately)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NineEighteenSocketIOManager.sharedInstance.closeConnection()
        HospitalitySocketIOManager.hospitalitySharedInstance.hospitalityCloseConnection()
    }
    
    //MARK:- Autologin
    func autoLogin() {
        let login = UserDefaults.standard.bool(forKey: "loginsuccess")
        if login {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "NineEighteenViewController") as! NineEighteenViewController
            let navVc = UINavigationController(rootViewController: initialViewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVc
            self.window?.makeKeyAndVisible()
        }
    }
    
    func hospitalityAutoLogin() {
        let login = UserDefaults.standard.bool(forKey: "hospitalityloginsuccess")
        if login {
            let storyboard = UIStoryboard(name: "Hospitality", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HospitalityTabbarControllerViewController") as! HospitalityTabbarControllerViewController
            let navVc = UINavigationController(rootViewController: initialViewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVc
            self.window?.makeKeyAndVisible()
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("message data" , remoteMessage.appData)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            badgeCount += 1
            UserDefaults.standard.set(badgeCount, forKey: "badgeCount")
            notificationcenter.post(name: Notification.Name("recivedPushN"), object: nil)
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}
