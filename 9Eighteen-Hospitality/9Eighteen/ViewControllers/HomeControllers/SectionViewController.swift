//
//  SectionViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 12/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {
    
    @IBOutlet weak var sectionTableview: UITableView!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var sectionType: UILabel!
    
    var id : Int!
    var catName : String!
    var catType : String!
    var sectionArray = [sectionData]()
    var cartDetails = [CartData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catApi()
        customMethod()
        sectionName.text! = catName
        sectionType.text! = catType
    }
    
    private func customMethod() {
        self.navigationItem.title = "MENU"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        sectionTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionTableViewCell")
        sectionTableview.tableFooterView = UIView()
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showCounter), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NineEighteenApis.isShow == true {
            showToast(message : "Item added to the cart")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NineEighteenApis.isShow = false
    }
    
    @objc func showCounter() {
        self.addBadge(itemvalue:String(CartData.getItemsCount()), isCart: true, isHospitality: false)
    }
    
//MARK:- Api calling
    private func catApi() {
        FSActivityIndicatorView.shared.show()
        let details = ["menuSectionId": "\(id!)"]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.catApi)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                FSActivityIndicatorView.shared.dismiss()
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        let results = json["results"] as! [[String:Any]]
                        for i in results {
                            self.sectionArray.append(sectionData(data: i))
                        }
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                DispatchQueue.main.async {
                    FSActivityIndicatorView.shared.dismiss()
                    self.sectionTableview.reloadData()
                }
            }
        }
    }
}

extension SectionViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! SectionTableViewCell
        cell.itemName.text! = sectionArray[indexPath.row].categoryName
        cell.itemPrice.text! = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let studentDVC = storyBoard.instantiateViewController(withIdentifier: "SubsectionViewController") as! SubsectionViewController
        studentDVC.id = sectionArray[indexPath.row].id
        studentDVC.menu_id = sectionArray[indexPath.row].sectionId
        studentDVC.subName = sectionArray[indexPath.row].categoryName
        navigationController?.pushViewController(studentDVC, animated: true)
    }
}
