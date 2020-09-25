//
//  ExploreViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
import Kingfisher
import CoreLocation

class ExploreViewController: UIViewController,LocationManagerDelegate {
    
    var lat  = ""
    var long = ""
    var resorts = [resort]()
    var resortsBussiness = [resortBussiness]()
    let label = UILabel()
    var window: UIWindow?
    var imageSDWebImageSrc = [KingfisherSource]()
    
    @IBOutlet weak var placeView: CardView!
    @IBOutlet weak var PlaceTableView: UITableView!
    @IBOutlet weak var dropdownButton: UIBarButtonItem!
    @IBOutlet weak var ExploreCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         HospitalitySocketIOManager.hospitalitySharedInstance.hospitalityEstablishConnection()
        PlaceTableView.register(UINib(nibName: "ChoosePlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "ChoosePlaceTableViewCell")
        ExploreCollectionView.register(UINib(nibName: "ExploreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCollectionViewCell")
        NotificationCenter.default.addObserver(self, selector:#selector(doYourStuff), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        customUI()
    }
    
    @objc func doYourStuff() {
         LocationServices.shared.locationManagerDelegate = self
         LocationServices.shared.startUpdatingLocation()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItemsCount()
        LocationServices.shared.locationManagerDelegate = self
        LocationServices.shared.startUpdatingLocation()
        FSActivityIndicatorView.shared.dismiss()
         NotificationCenter.default.addObserver(self, selector: #selector(fetchNewMessages(_:)), name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.newchats.rawValue), object: nil)
    }
    
    @objc private func fetchNewMessages(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let newList = userInfo["newChat"] as! [[String:Any]]
            for i in newList {
                createAlert(order: i["order_id"] as? String, driverId: i["driver_id"] as? String)
            }
        }
    }
    private func createAlert(order:String!,driverId:String!) {
        let alert = UIAlertController(title: "Hospitality", message: "You have a new message regarding a Hospitality order", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "View", style: UIAlertAction.Style.default, handler: { (action) in
           let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
           let studentDVC = storyBoard.instantiateViewController(withIdentifier: "HospitalityChatViewController") as! HospitalityChatViewController
            studentDVC.order = order
            studentDVC.driverId = driverId
            self.navigationController?.pushViewController(studentDVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func customUI() {
        showCounter()
        placeView.isHidden = true
        ExploreCollectionView.isHidden = true
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(dataTask.badgeCount), isCart: false, isHospitality: true)
    }
    
    //Mark:- Count
    @objc func getItemsCount() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            if(HospitalityCartData.getToppingsCount() == 0){
                tabItem.badgeValue = nil
            }else{
                tabItem.badgeValue = String(HospitalityCartData.getToppingsCount())
            }
        }
    }
    
    @IBAction func dropdownAction(_ sender: Any) {
        self.placeView.isHidden = false
        self.ExploreCollectionView.isHidden = true
        HospitalityNineEighteenApis.isSelected = false
        self.label.isHidden = true
        self.PlaceTableView.isHidden = false
        homeApi()
    }
    
    //MARK:- Locations
    func getLocation(location: CLLocation,isLocationfetched:Bool) {
        if((LocationServices.shared.isLocationfetched == false)){
            HospitalityNineEighteenApis.isSelected = false
            self.bgLabel(message: "Please open settings -> Select the 9-Eighteen App -> Select location -> Choose “Always” and open the app again, then a menu will be present.")
        }else{
            self.label.isHidden = true
            let location: CLLocationCoordinate2D = location.coordinate
            lat = String(location.latitude)
            long = String(location.longitude)
            LocationServices.shared.locationManagerDelegate = nil
            LocationServices.shared.stopUpdatingLocation()
            if(HospitalityNineEighteenApis.isSelected == false){
                homeApi()
            }else{
                getBusinessApi()
            }
        }
    }
    
    //MARK:- Api Calling
    private func homeApi() {
        CoreDataStack.shared.deleteOrderedItems()
        FSActivityIndicatorView.shared.show()
        let details = ["latitude" : "\(lat)" , "longitude" : "\(long)" ,"user_id" : "\(dataTask.LoginData().user_id!)"]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.fetchHome)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let status = json["status"] as? Int else {return}
                    if(status == 200){
                        let data = json["data"] as? [String:Any]
                        let hasMultiple = data!["hasMultiple"] as? Bool
                        if(hasMultiple == true){
                            self.placeView.isHidden = false
                            self.PlaceTableView.isHidden = false
                            if let resortData = data!["resort"] as? [[String:Any]] {
                                for i in resortData {
                                    if !self.resorts.contains(where: {($0.id == i["id"] as? Int)}){
                                        self.resorts.append(resort(data: i))
                                    }else{
                                        print("item already exist")
                                    }
                                }
                            }
                        }
                        else {
                            self.placeView.isHidden = true
                            self.ExploreCollectionView.isHidden = false
                            let resort = data!["resort"] as? [[String:Any]]
                            let resortID = resort?.first
                            let id = resortID!["id"] as? Int
                            UserDefaults.standard.set(id!,forKey: "hospitalitycourseId")
                            self.getBusinessApi()
                        }
                    }
                    else{
                        self.label.isHidden = false
                        FSActivityIndicatorView.shared.dismiss()
                        guard let message = json["message"] as? String else {return}
                        self.bgLabel(message: message)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.PlaceTableView.reloadData()
                }
            }
        }
    }
    
    private func getBusinessApi(){
        self.imageSDWebImageSrc.removeAll()
        self.ExploreCollectionView.delegate = self
        self.ExploreCollectionView.dataSource = self
        self.placeView.isHidden = true
        self.ExploreCollectionView.isHidden = false
        FSActivityIndicatorView.shared.show()
        let details = ["resort_id" : "\(dataTask.HospitalityData().hospitalitycourseId!)","latitude" : "\(lat)" , "longitude" : "\(long)" ]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.getResortBussiness)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let status = json["status"] as? Int else {return}
                    if(status == 200){
                        self.onesignal()
                        self.label.isHidden = true
                        if let data = json["data"] as? [[String:Any]] {
                            for i in data {
                                if !self.resortsBussiness.contains(where: {($0.id == i["id"] as? Int)}){
                                    self.resortsBussiness.append(resortBussiness(data: i))
                                }else{
                                    print("item already exist")
                                }
                            }
                            for image in self.resortsBussiness {
                                if(image.img_url != ""){
                                    let image = KingfisherSource(urlString: image.img_url)
                                    self.imageSDWebImageSrc.append(image!)
                                }
                            }
                        }
                    } else {
                        self.label.isHidden = false
                        FSActivityIndicatorView.shared.dismiss()
                        guard let message = json["message"] as? String else {return}
                        self.bgLabel(message: message)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.ExploreCollectionView.reloadData()
                }
            }
        }
    }
    
    private func bgLabel(message : String!) {
        label.isHidden = false
        self.ExploreCollectionView.isHidden = true
        self.placeView.isHidden = true
        self.PlaceTableView.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = UIColor.white
        label.font = UIFont(name: "Poppins-Regular", size: 18.0)
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
   
    private func onesignal() {
        guard let token = UserDefaults.standard.object(forKey: "fcmToken") as? String else {return}
        let details = ["type": "user" , "phone" : dataTask.LoginData().mobileNo!, "oneSignalId" : "\(token)"]
        print(details)
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.addOneSignalId)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    if let _ = json["data"] as? [String:Any] {
                    }
                }
            }
        }
    }
}

extension ExploreViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePlaceTableViewCell", for: indexPath) as! ChoosePlaceTableViewCell
        cell.ChooseName.text! = resorts[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(resorts[indexPath.row].id!, forKey: "hospitalitycourseId")
        HospitalityNineEighteenApis.isSelected = true
        self.getBusinessApi()
    }
}

extension ExploreViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ImageSlideshowDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resortsBussiness.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionViewCell", for: indexPath as IndexPath) as! ExploreCollectionViewCell
        myCell.itemImage.sd_setImage(with: URL(string: resortsBussiness[indexPath.row].img_url), placeholderImage: UIImage(named: "resort"))
        myCell.itemTitle.text! = resortsBussiness[indexPath.row].name!
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  8
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ExploreCollectionReusableView", for: indexPath) as! ExploreCollectionReusableView
        headerView.slideshow.slideshowInterval = 2.0
        headerView.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        headerView.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.init(hexString: "#0C6E4C")
        pageControl.pageIndicatorTintColor = UIColor.white
        headerView.slideshow.pageIndicator = pageControl
        headerView.slideshow.layer.cornerRadius = 6
        headerView.slideshow.clipsToBounds = true
        headerView.slideshow.activityIndicator = DefaultActivityIndicator()
        headerView.slideshow.delegate = self
        headerView.slideshow.setImageInputs(imageSDWebImageSrc)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Hospitality", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "ExploreDetailViewController") as! ExploreDetailViewController
        studentDVC.resortsBussiness = [resortsBussiness[indexPath.row]]
        navigationController?.pushViewController(studentDVC, animated: true)
    }
}
