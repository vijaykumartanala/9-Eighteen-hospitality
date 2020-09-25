//
//  HomePopViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 07/05/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HomePopViewController: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    var courseData = [courses]()
    var selCourse = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        })
      HomeTableView.register(UINib(nibName: "ChoosePlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "ChoosePlaceTableViewCell")
    }
}

extension HomePopViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePlaceTableViewCell", for: indexPath) as! ChoosePlaceTableViewCell
        cell.ChooseName.text! = courseData[indexPath.row].course!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selCourse.append([
            "course": courseData[indexPath.row].course,
            "exists":courseData[indexPath.row].exists!,
            "tipPerc1":courseData[indexPath.row].tipPerc1!,
            "tipPerc2":courseData[indexPath.row].tipPerc2!,
            "tipPerc3":courseData[indexPath.row].tipPerc3!,
            "isMember":courseData[indexPath.row].isMember!,
            "courseId":courseData[indexPath.row].courseId!,
            "foreupCourseId":courseData[indexPath.row].foreupCourseId!,
            "currency":courseData[indexPath.row].currencyCode!
        ])
        NotificationCenter.default.post(name: Notification.Name(rawValue: NineEighteenConstants.NotificationIdentifiers.selectedCourse.rawValue), object: nil, userInfo: ["selectedCourse": selCourse])
        self.dismiss(animated: true, completion: nil)
    }
}
