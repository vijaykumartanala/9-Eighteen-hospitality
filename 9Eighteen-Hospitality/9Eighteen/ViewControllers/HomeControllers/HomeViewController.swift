//
//  HomeViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreLocation
import AVKit
import AVFoundation

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    
    lazy var mySections: [accomplishmentData] = {
        let section1 = accomplishmentData(title: "Menu Locations")
        let section2 = accomplishmentData(title: "Popular Items")
        return [section1, section2]
    }()
    
    @IBOutlet weak var itemsTableViewController: UITableView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseButton: UIButton!
    
    var locationManager = CLLocationManager()
    var lat  = ""
    var long = ""
    var menu = [menuData]()
    var popularItem = [popularItems]()
    var courseData = [courses]()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let label = UILabel()
    let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        showCounter()
        NineEighteenSocketIOManager.sharedInstance.establishConnection()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.setHidesBackButton(true, animated: false)
        NotificationCenter.default.addObserver(self, selector:#selector(doYourStuff), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func doYourStuff() {
        locationUpdates()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Custom Method
    func addNavBarImage() {
        appdelegate.notificationcenter.addObserver(self, selector: #selector(showCounter), name: Notification.Name("recivedPushN"), object: nil)
        itemsTableViewController.register(UINib(nibName: "HomeLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeLocationTableViewCell")
        itemsTableViewController.register(UINib(nibName: "HomePopularItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePopularItemsTableViewCell")
        itemsTableViewController.register(UINib(nibName: "StaticDataTableViewCell", bundle: nil), forCellReuseIdentifier: "StaticDataTableViewCell")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        let imageView = UIImageView(image: UIImage(named: "9-Eighteen_"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.itemsTableViewController.isHidden = true
        courseButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectCourse(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.selectedCourse.rawValue), object: nil)
        locationUpdates()
        if NineEighteenApis.isShow == true {
            showToast(message : "Item added to the cart")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NineEighteenApis.isShow = false
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.selectedCourse.rawValue), object: nil)
    }
    
    @objc private func fetchNewMessages(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let newList = userInfo["newChat"] as! [[String:Any]]
            for i in newList {
                createAlert(order: i["order_id"] as? String, driverId: i["driver_id"] as? String)
            }
        }
    }
    
    @objc private func selectCourse(_ notification: Notification) {
        NineEighteenApis.isCourseSelected = true
        CoreDataStack.shared.deleteContext()
        self.menu.removeAll()
        self.popularItem.removeAll()
        if let courseData = notification.userInfo {
            let selected = courseData["selectedCourse"] as! [[String:Any]]
            if(selected[0]["exists"] as! Bool){
                NineEighteenApis.exits = false
                UserDefaults.standard.set(selected[0]["courseId"] as! String, forKey: "courseId")
                UserDefaults.standard.set(selected[0]["foreupCourseId"] as! String, forKey: "foreupId")
                UserDefaults.standard.set(selected[0]["course"] as! String, forKey: "courseName")
                UserDefaults.standard.set(selected[0]["isMember"] as! Int, forKey: "isMember")
                NineEighteenApis.tip1  = selected[0]["tipPerc1"] as? Double ?? 0.00
                NineEighteenApis.tip2 = selected[0]["tipPerc2"] as? Double ?? 0.00
                NineEighteenApis.tip3 = selected[0]["tipPerc3"] as? Double ?? 0.00
                NineEighteenApis.tip4 = selected[0]["tipPerc4"] as? Double ?? 0.00
                NineEighteenApis.currencyCode = selected[0]["currency"] as? String ?? ""
                if selected[0]["courseId"] as! String != dataTask.LoginData().courseId! {
                    CoreDataStack.shared.deleteContext()
                }
                self.menuApi(courseId:selected[0]["courseId"] as! String)
                self.courseName.text! = selected[0]["course"] as! String
            }else{
                self.label.isHidden = false
                NineEighteenApis.exits = true
                FSActivityIndicatorView.shared.dismiss()
                self.bgLabel(message: "You are currently not at a 9-Eighteen partner course.")
            }
        }
    }
    
    private func createAlert(order:String!,driverId:String!) {
        let alert = UIAlertController(title: "9-Eighteen", message: "You have a new message regarding a 9-Eighteen order", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "View", style: UIAlertAction.Style.default, handler: { (action) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            studentDVC.order = order
            studentDVC.driverId = driverId
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func locationUpdates(){
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled() == true){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 50
            locationManager.allowsBackgroundLocationUpdates = true
            let location = locationManager.location?.coordinate
            if(location == nil){
                self.bgLabel(message: "Please open settings -> Select the 9-Eighteen App -> Select location -> Choose “Always” and open the app again, then a menu will be present.")
            }else{
                self.label.isHidden = true
            }
        }
        else {
            locationAuthorizationStatus()
        }
    }
    
    func locationAuthorizationStatus(){
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            createAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = String(location.latitude)
        long = String(location.longitude)
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        homeApi()
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: false)
    }
    
    @IBAction func selectCourseButton(_ sender: Any) {
        NineEighteenApis.isCourseSelected = false
        homeApi()
    }
    
    //MARK:- Api Calling (Latest build)
    private func homeApi() {
        courseButton.isHidden = true
        self.courseData.removeAll()
        if(lat == "" || long == ""){
            createAlert()
        }else{
            FSActivityIndicatorView.shared.show()
            let details = ["phoneNumber": "\(dataTask.LoginData().mobileNo!)" , "latitude" : "\(lat)" , "longitude" : "\(long)" ,"userId" : "\(dataTask.LoginData().user_id!)"]
            print(details)
            ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.homeApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    if let unwrappedError = error {
                        print(unwrappedError.localizedDescription)
                    }
                    if let json = response {
                        if let success = json["success"] as? Bool {
                            if success == true {
                                guard let course = json["courses"] as? [[String:Any]] else {return}
                                for i in course {
                                    self.courseData.append(courses(data:i))
                                }
                                if self.courseData.count == 1{
                                    let exist = self.courseData.first!.exists
                                    if exist == true {
                                        NineEighteenApis.exits = false
                                        UserDefaults.standard.set(self.courseData.first!.courseId!, forKey: "courseId")
                                        UserDefaults.standard.set(self.courseData.first!.foreupCourseId!, forKey: "foreupId")
                                        UserDefaults.standard.set(self.courseData.first!.course!, forKey: "courseName")
                                        UserDefaults.standard.set(self.courseData.first!.isMember!, forKey: "isMember")
                                        NineEighteenApis.tip1  = self.courseData.first!.tipPerc1!
                                        NineEighteenApis.tip2 = self.courseData.first!.tipPerc2!
                                        NineEighteenApis.tip3 = self.courseData.first!.tipPerc3!
                                        NineEighteenApis.tip4 = self.courseData.first!.tipPerc4!
                                        NineEighteenApis.currencyCode = self.courseData.first!.currencyCode!
                                        if self.courseData.first!.courseId != dataTask.LoginData().courseId! {
                                            CoreDataStack.shared.deleteContext()
                                        }
                                        self.menuApi(courseId:self.courseData.first!.courseId!)
                                        self.courseName.text! = self.courseData.first!.course!
                                    }
                                    else {
                                        self.label.isHidden = false
                                        NineEighteenApis.exits = true
                                        FSActivityIndicatorView.shared.dismiss()
                                        if(AppDelegate.count == 0){
                                            self.playVideo()
                                            AppDelegate.count = 1
                                        }
                                        guard let message = json["message"] as? String else {return}
                                        self.bgLabel(message: message)
                                    }
                                } else if self.courseData.count > 1{
                                    self.courseButton.isHidden = false
                                    if(NineEighteenApis.isCourseSelected == false){
                                        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "HomePopViewController") as!  HomePopViewController
                                        newViewcontroller.courseData = self.courseData
                                        newViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                                        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
                                            self.present(newViewcontroller, animated: true, completion:nil) })
                                    }else{
                                        NineEighteenApis.exits = false
                                        self.menuApi(courseId:dataTask.LoginData().courseId!)
                                        self.courseName.text! = dataTask.LoginData().courseName!
                                    }
                                } else {
                                    self.label.isHidden = false
                                    NineEighteenApis.exits = true
                                    FSActivityIndicatorView.shared.dismiss()
                                    if(AppDelegate.count == 0){
                                        self.playVideo()
                                        AppDelegate.count = 1
                                    }
                                    guard let message = json["message"] as? String else {return}
                                    self.bgLabel(message: message)
                                }
                            } else {
                                self.label.isHidden = false
                                NineEighteenApis.exits = true
                                FSActivityIndicatorView.shared.dismiss()
                                if(AppDelegate.count == 0){
                                    self.playVideo()
                                    AppDelegate.count = 1
                                }
                                guard let message = json["message"] as? String else {return}
                                self.bgLabel(message: message)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Menu Api
    private func menuApi(courseId : String) {
        FSActivityIndicatorView.shared.show()
        let details = ["courseId": "\(courseId)" , "from" : "mobile"]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.menuApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    if let success = json["success"] as? Bool {
                        if success == true {
                            if self.isFirstLaunch{
                               self.onesignal()
                            }
                            self.label.isHidden = true
                            self.menu.removeAll()
                            self.popularItem.removeAll()
                            FSActivityIndicatorView.shared.dismiss()
                            let results = json["results"] as! [String:Any]
                            let menuSec = results["menusection"] as! [[String:Any]]
                            let popular = results["popularitems"] as! [[String:Any]]
                            if menuSec.count == 0 && popular.count == 0 {
                                self.itemsTableViewController.isHidden = false
                            }
                            else {
                                for i in menuSec {
                                    if !self.menu.contains(where: {($0.id == i["id"] as? Int)}){
                                        self.menu.append(menuData(data: i))
                                    }else{
                                        print("item already exist")
                                    }
                                }
                                for j in popular {
                                    if !self.popularItem.contains(where: {($0.id == j["id"] as? Int)}){
                                        self.popularItem.append(popularItems(data: j))
                                    }else{
                                        print("item already exist")
                                    }
                                }
                            }
                        }
                        else {
                            self.label.isHidden = false
                            FSActivityIndicatorView.shared.dismiss()
                            guard let message = json["message"] as? String else {return}
                            self.bgLabel(message: message)
                        }
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.itemsTableViewController.reloadData()
                }
            }
        }
    }
    
//MARK:- Menu Api
    private func onesignal() {
        guard let token = UserDefaults.standard.object(forKey: "fcmToken") as? String else {return}
        let details = ["type": "user" , "phone" : dataTask.LoginData().mobileNo!, "oneSignalId" : "\(token)"]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.oneSignalApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    if let success = json["success"] as? Bool {
                        if success == true {
                        }
                        else {
                            
                        }
                    }
                }
            }
        }
    }
    
    private func playVideo() {
        guard let path = URL(string: "https://qa.9-eighteen.com/api/v1/views/promote.mp4") else {
            debugPrint("video not found")
            return
        }
        let player = AVPlayer(url: path)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    private func createAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Please share the location from settings to be able to use the app and order food and beverages from 9-Eighteen", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.label.isHidden = false
            self.bgLabel(message: "Please turn on your location to order food and beverages from 9-Eighteen")
        }))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func profileButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        navigationController?.pushViewController(studentDVC, animated: true)
    }
    
    private func bgLabel(message : String!) {
        self.itemsTableViewController.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Poppins-Regular", size: 16.0)
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menu.count == 0 && popularItem.count == 0 {
            tableView.setEmptyMessage("You are currently not at a 9-Eighteen partner course. To learn more about 9-Eighteen or to find out how your golf course can use 9-Eighteen technology- visit us at 9-Eighteen.com")
        }
        else {
            tableView.restore()
            self.itemsTableViewController.isHidden = false
            if section == 0 {
                return menu.count
            }
            return popularItem.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLocationTableViewCell", for: indexPath) as! HomeLocationTableViewCell
            cell.locationItem.text! = menu[indexPath.row].name
            return cell
        }
        else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "HomePopularItemsTableViewCell", for: indexPath) as! HomePopularItemsTableViewCell
            cell1.itemName.text! = popularItem[indexPath.row].name
            cell1.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(popularItem[indexPath.row].price!)))
            return cell1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if menu.count == 0 && popularItem.count == 0 {
            let view = UIView()
            view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 240/255)
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: view.center.x + 20, y: 20, width:170, height: 18)
            titleLabel.text = ""
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            view.addSubview(titleLabel)
            return view
        }
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 255/255)
        let headerImage: UIImage = UIImage(named: "location_icon")!
        let headerView = UIImageView(image: headerImage)
        headerView.frame = CGRect(x: 15, y: 10, width: 33, height: 33)
        headerView.contentMode = .scaleAspectFit
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: view.center.x + 20, y: 10, width:170, height: 18)
        titleLabel.text = mySections[section].title
        titleLabel.textColor = UIColor.black
        titleLabel.font =  UIFont(name: "Poppins-Bold", size: 17.0)
        view.addSubview(titleLabel)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
            studentDVC.id = menu[indexPath.row].id
            studentDVC.catName = courseName.text!
            studentDVC.catType = menu[indexPath.row].name
            navigationController?.pushViewController(studentDVC, animated: true)
        }
        if indexPath.section == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let studentDVC = storyBoard.instantiateViewController(withIdentifier: "DetailPopularItemsViewController") as! DetailPopularItemsViewController
            studentDVC.popularItem = [popularItem[indexPath.row]]
            studentDVC.selectedItem = popularItem[indexPath.row].name
            navigationController?.pushViewController(studentDVC, animated: true)
        }
    }
}

struct accomplishmentData {
    let title: String
}

extension String {
    
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedStringKey.font: font,
                                        NSAttributedStringKey.foregroundColor: color])
        let boldFontAttribute = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let term = "9-eighteen.com"
        let formattedText = String.format(strings: [term],
                                          boldFont: UIFont.boldSystemFont(ofSize: 15),
                                          boldColor: UIColor.blue,
                                          inString: message,
                                          font: UIFont.systemFont(ofSize: 15),
                                          color: UIColor.black)
        messageLabel.attributedText = formattedText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTermTapped))
        messageLabel.addGestureRecognizer(tap)
        messageLabel.isUserInteractionEnabled = true
        self.backgroundView  = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.9-eighteen.com/") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

