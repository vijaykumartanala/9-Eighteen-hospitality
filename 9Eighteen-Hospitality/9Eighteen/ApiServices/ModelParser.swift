//
//  ModelParser.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 10/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

public class ModelParser: NSObject {
    
    public class func postApiServices
        (urlToExecute : URL ,parameters : [String:Any] , methodType : String ,accessToken : Bool,completionHandler : @escaping ([String:Any]?, Error?)->Void) {
        dataTask.beginURLSession(with: urlToExecute, methodType: methodType, accessToken: accessToken, parameters: parameters, completion: { (data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                completionHandler(json, nil)
                
            } catch {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        })
    }
}
