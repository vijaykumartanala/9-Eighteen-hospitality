//
//  dataTask.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

public class dataTask: NSObject {
    static var badgeCount = 0
    public class func beginURLSession(with urlString: URL, methodType : String,accessToken : Bool,
                                      parameters : [String:Any],completion: @escaping(Data) -> ()) {
        var request = URLRequest(url: urlString)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if methodType == "POST" {
            request.httpMethod = "POST"
            request.setValue("https://qa.9-eighteen.com", forHTTPHeaderField: "origin")
            if accessToken == true {
                request.setValue("Bearer " + dataTask.LoginData().token!, forHTTPHeaderField: "Authorization")
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        }
        else if methodType == "GET" {
            request.httpMethod = "GET"
            request.setValue("https://qa.9-eighteen.com", forHTTPHeaderField: "origin")
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {  print("error : ", error);  return }
            guard let data = data else { return }
            completion(data)
            }.resume()
    }
    
    struct LoginData {
        
        var user_id : String! {return UserDefaults.standard.string(forKey: "user_id") ?? ""  }
        
        var mobileNo : String! {return UserDefaults.standard.string(forKey: "mobileNumber") ?? "" }
        
        var courseId : String! {return UserDefaults.standard.string(forKey: "courseId") ?? "" }

        var member : Int! {return UserDefaults.standard.integer(forKey: "isMember") }
        
        var courseName : String! {return UserDefaults.standard.string(forKey: "courseName") ?? "" }
        
        var token : String! {return UserDefaults.standard.string(forKey: "token") ?? "" }
        
        var forupId : String! {return UserDefaults.standard.string(forKey: "foreupId") ?? "" }
        
      }
    
    struct HospitalityData {
        
        var hospitalitycourseId : Int! {return UserDefaults.standard.integer(forKey: "hospitalitycourseId") }
        
    }
    
}

