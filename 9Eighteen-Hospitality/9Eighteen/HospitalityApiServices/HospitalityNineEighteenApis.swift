//
//  HospitalityNineEighteenApis.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 08/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class HospitalityNineEighteenApis {
    
    static let shared = HospitalityNineEighteenApis()
    //static let baseUrl = "https://7cbd715b.ngrok.io/"
     static let baseUrl = "https://hospitality.9-eighteen.com/api/v1/"
     let existsApi = "\(baseUrl)" + "doesExist"
     let userLogin = "\(baseUrl)" + "appUserLogin"
     let verifySms = "\(baseUrl)" + "verifySMS"
     let resetPassword = "\(baseUrl)" + "resetAppPassword"
     let forgotPassword = "\(baseUrl)" + "forgotAppPassword"
     let validateOtp = "\(baseUrl)" + "validateAppOTP"
     let fetchHome = "\(baseUrl)" + "fetchHomeInfo"
     let getResortBussiness = "\(baseUrl)" + "getAppResortBusinesses"
     let getResortBussinessItems = "\(baseUrl)" + "getBusinessItems"
     let submitOrder = "\(baseUrl)" + "submitOrder"
     let generateToken =  "\(baseUrl)" + "generateBSToken"
     let resortOrder = "\(baseUrl)" + "getOrders"
     let changeHospitalityPaymentStatus = "\(baseUrl)" + "changeOrderStatus"
     let getProfile = "\(baseUrl)" + "getAppUserProfile"
     let changePassword = "\(baseUrl)" + "changeAppPassword"
     let updateProfile = "\(baseUrl)" + "updateAppUserProfile"
     let getMessages = "\(baseUrl)" + "getMessages"
     let addOneSignalId = "\(baseUrl)" + "addOneSignalId"
     let getNotifications = "\(baseUrl)" + "getNotifications"
     let logoutApi = "\(baseUrl)" + "logout"
     let locationUpdate = "\(baseUrl)" + "locationUpdate"
    
     static var isSelected = false;
}
