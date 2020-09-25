//
//  menuData.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 17/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit



struct courses {
    
    var course : String!
    var exists : Bool!
    var tipPerc1 : Double!
    var tipPerc2 : Double!
    var tipPerc3 : Double!
    var tipPerc4 : Double!
    var isMember : Int!
    var courseId : String!
    var foreupCourseId : String!
    var currencyCode : String!
    
    init(data:[String:Any]) {
        course = data["course"] as? String ?? ""
        exists = data["exists"] as? Bool ?? false
        tipPerc1 = data["tipPerc1"] as? Double ?? 0.00
        tipPerc2  = data["tipPerc2"] as? Double ?? 0.00
        tipPerc3 = data["tipPerc3"] as? Double ?? 0.00
        tipPerc4 = data["tipPerc4"] as? Double ?? 0.00
        isMember = data["isMember"] as? Int 
        courseId = data["courseId"] as? String
        foreupCourseId = data["foreupCourseId"] as? String ?? "null"
        currencyCode = data["currency"] as? String ?? ""
    }
}

 struct menuData {

    var id : Int!
    var name : String!
    var courseId : String!
 
    init(data:[String:Any]) {
       id = data["id"] as? Int ?? 0
       name = data["name"] as? String ?? ""
       courseId = data["courseId"] as? String ?? ""
    }
}

 struct homeData {

    var isMember : Bool!
    var course : String!
    var menuSectionId : Int!
    var pickupTime : String!
    var courseId : String!
    var tipPerc1 : Double!
    var tipPerc2 : Double!
    var tipPerc3 : Double!
    
    init(data:[String:Any]) {
       isMember = data["isMember"] as? Bool ?? false
       course = data["course"] as? String ?? ""
       menuSectionId = data["menuSectionId"] as? Int ?? 0
       pickupTime = data["pickupTime"] as? String ?? ""
       courseId = data["courseId"] as? String ?? ""
       tipPerc1 = data["tipPerc1"] as? Double ?? 0.0
       tipPerc2 = data["tipPerc2"] as? Double ?? 0.0
       tipPerc3 = data["tipPerc3"] as? Double ?? 0.0
    }
}


struct popularItems {
    
    var name : String!
    var price : Double!
    var foodDesc : String!
    var tax : String!
    var id : Int!
    var quantity : Int!
    var menuSectionId : Int!
    
    init(data:[String:Any]) {
        name = data["name"] as? String ?? ""
        price = data["price"] as? Double ?? 0.00
        foodDesc = data["foodDescription"] as? String ?? ""
        tax  = data["Tax"] as? String ?? ""
        id = data["id"] as? Int ?? 0
        quantity = data["quantity"] as? Int ?? 1
        menuSectionId = data["menuSectionId"] as? Int
    }
}

struct sectionData {
    var id : Int!
    var categoryName : String!
    var sectionId : Int!
    
    init(data:[String:Any]) {
        id = data["id"] as? Int ?? 0
        categoryName = data["category_name"] as? String ?? ""
        sectionId = data["menuSectionId"] as? Int ?? 0
    }
}

struct subSectionData {
    
    var id : Int!
    var name : String!
    var foodDesc : String!
    var price : Double!
    var tax : String!
    var isSelected : Bool!
    
    init(data: [String:Any]) {
       id = data["id"] as? Int ?? 0
       name = data["name"] as? String ?? ""
       foodDesc = data["foodDescription"] as? String ?? ""
       price = data["price"] as? Double ?? 0.0
       tax = data["Tax"] as? String ?? ""
       isSelected = false
    }
}

struct orderData {
    
    var id : Int!
    var cardholder : String!
    var count : Int!
    var status : String!
    var time : Int!
    var totalPrice : Double!
    var user_id : Int!
    var databaseId : Int!
    var driver_id : Int!
    var date : String!
    var address : String!
    var adminPhone : String!
    var courseName : String!
    
    init(data: [String:Any]) {
        id = data["Id"] as? Int ?? 0
        cardholder = data["cardholder"] as? String ?? ""
        count = data["count"] as? Int ?? 0
        status = data["status"] as? String ?? ""
        time = data["time"] as? Int ?? 0
        totalPrice = data["totalPrice"] as? Double ?? 0.00
        user_id = data["user_id"] as? Int ?? 0
        databaseId = data["databaseId"] as? Int ?? 0
        driver_id = data["driverId"] as? Int ?? 0
        date = data["date"] as? String ?? ""
        address = data["address"] as? String ?? ""
        adminPhone = data["adminPhone"] as? String ?? ""
        courseName = data["courseName"] as? String ?? ""
    }
}

struct orderDetailsData {
    
    var orderId : Int!
    var itemNote : String!
    var tbl_item : [String:Any]!
    var name : String!
    var categoryId : Int!
    var price : Double!
    var quantity : Int!
    var address : String!
    var adminPhone : String!
    
    init(data: [String:Any]) {
        orderId = data["orderId"] as? Int ?? 0
        itemNote = data["itemNote"] as? String ?? ""
        tbl_item = data["tbl_item"] as? [String:Any] ?? [:]
        name = tbl_item["name"] as? String
        categoryId = tbl_item["categoryId"] as? Int
        price = tbl_item["price"] as? Double ?? 0.00
        quantity = data["quantity"] as? Int ?? 0
        address = data["address"] as? String ?? ""
        adminPhone = data["adminPhone"] as? String ?? ""
    }
}

struct messagesData {
    
    var message_id : Int!
    var message : String!
    var sender : Int!
    init(data: [String:Any]) {
        message_id = data["message_id"] as? Int ?? 0
        message = data["message"] as? String ?? ""
        sender = data["sender"] as? Int ?? 0
    }
}

struct notificationsData {
    
    var order_id : Int!
    var notification : String!
    var driver_id : Int!
    var type  : String!
    
    init(data: [String:Any]) {
        order_id = data["order_id"] as? Int ?? 0
        notification = data["message"] as? String ?? ""
        driver_id = data["driver_id"] as? Int ?? 0
        type = data["type"] as? String ?? ""
    }
}
