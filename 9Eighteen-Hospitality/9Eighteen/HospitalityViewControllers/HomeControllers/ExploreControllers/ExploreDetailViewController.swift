//
//  ExploreDetailViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 19/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ExploreDetailViewController: UIViewController {
    
    var bussinessItems = [resortBussinessItems]()
    var resortsBussiness = [resortBussiness]()
    var arrSelectedRows = [Int]()
    var orderDetails = [HospitalityItems]()
    
    @IBOutlet weak var itemDetails: UITableView!
    @IBOutlet weak var bussinessImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = resortsBussiness.first!.name!
        itemDetails.register(UINib(nibName: "ItemDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemDetailTableViewCell")
        itemDetails.allowsMultipleSelection = true
        bussinessImage.sd_setImage(with: URL(string: resortsBussiness.first!.img_url), placeholderImage: UIImage(named: "resort"))
        customMethod()
         _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showCounter), userInfo: nil, repeats: true)
    }
    
//MARK:- Custom Methods
    private func customMethod(){
        self.orderDetails = HospitalityCartData.fetchItemDetails()
        if(self.orderDetails.count > 0) {
            for i in orderDetails {
                self.arrSelectedRows.append(Int(i.id))
            }
        }
        getBusinessItemsApi()
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(HospitalityCartData.getToppingsCount()), isCart: true, isHospitality: true)
    }
    
//MARK:-Api Calling
    private func getBusinessItemsApi(){
        FSActivityIndicatorView.shared.show()
        let details = ["business_id" : "\(resortsBussiness.first!.id!)"]
        ModelParser.postApiServices(urlToExecute: URL(string:HospitalityNineEighteenApis.shared.getResortBussinessItems)!, parameters: details, methodType: "POST", accessToken: true) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    guard let status = json["status"] as? Int else {return}
                    if(status == 200){
                        if let data = json["data"] as? [[String:Any]] {
                            for i in data {
                                self.bussinessItems.append(resortBussinessItems(data: i))
                            }
                        }
                    } else {
                        FSActivityIndicatorView.shared.dismiss()
                        guard let message = json["message"] as? String else {return}
                        self.bgLabel(message: message)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.itemDetails.reloadData()
                }
            }
        }
    }
    
    private func bgLabel(message : String!) {
        self.itemDetails.isHidden = true
        let label = UILabel()
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

extension ExploreDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bussinessItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bussinessItems[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailTableViewCell", for: indexPath) as! ItemDetailTableViewCell
        if(self.arrSelectedRows.contains(bussinessItems[indexPath.section].itemArray[indexPath.row].id!)){
            cell.addView.isHidden = true
            cell.addButton.isHidden = true
            cell.countView.isHidden = false
            if(orderDetails.count > 0){
                for item in orderDetails {
                    if(bussinessItems[indexPath.section].itemArray[indexPath.row].id! == item.id){
                        bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount = Int(item.itemCount)
                    } else {
                        cell.itemCount.text! = "\(bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!)"
                    }
                }
            } else {
                cell.itemCount.text! = "\(bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!)"
            }
        } else {
            cell.addView.isHidden = false
            cell.addButton.isHidden = false
            cell.countView.isHidden = true
        }
        cell.exploreItems = self
        cell.isExplore = true
        cell.bussiness_id = resortsBussiness.first!.id!
        cell.delivery_type = resortsBussiness.first!.delivery_type!
        cell.headerTitle = resortsBussiness.first!.name!
        cell.image_url = resortsBussiness.first!.img_url!
        cell.tip1 = resortsBussiness.first!.tip1
        cell.tip2 = resortsBussiness.first!.tip2
        cell.tip3 = resortsBussiness.first!.tip3
        cell.exploreData(item: bussinessItems[indexPath.section].itemArray[indexPath.row])
        cell.itemPrice.text! = "$ " + String(format: "%.2f" ,(Double(bussinessItems[indexPath.section].itemArray[indexPath.row].price!) * (Double(bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!))))
        cell.itemCount.text! = "\(bussinessItems[indexPath.section].itemArray[indexPath.row].itemCount!)"
        cell.itemTitle.text! = bussinessItems[indexPath.section].itemArray[indexPath.row].name
        cell.itemDesc.text! = bussinessItems[indexPath.section].itemArray[indexPath.row].description
        cell.addButton.tag =  Int(bussinessItems[indexPath.section].itemArray[indexPath.row].id!)
        cell.minusButton.tag = Int(bussinessItems[indexPath.section].itemArray[indexPath.row].id!)
        cell.plusButton.tag = Int(bussinessItems[indexPath.section].itemArray[indexPath.row].id!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .white
        headerView.backgroundView?.backgroundColor = .black
        headerView.textLabel?.textColor = UIColor.init(hexString: "#3B88C3")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return bussinessItems[section].name
    }
}
