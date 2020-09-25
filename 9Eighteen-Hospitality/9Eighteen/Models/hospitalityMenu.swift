//
//  hospitalityMenu.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 18/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

struct resort {
    
    var id : Int!
    var name : String!
    
    init(data:[String:Any]) {
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        
    }
}

struct resortBussiness {
    
    var id : Int!
    var name : String!
    var img_url : String!
    var delivery_type : String!
    var tip1 : Double!
    var tip2 : Double!
    var tip3 : Double!
    
    init(data:[String:Any]) {
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        img_url = data["img_url"] as? String ?? ""
        delivery_type = data["delivery_type"] as? String ?? ""
        tip1 = data["tip1"] as? Double ?? 0.00
        tip2 = data["tip2"] as? Double ?? 0.00
        tip3 = data["tip3"] as? Double ?? 0.00
    }
}

struct resortBussinessItems {
    
    var name : String!
    var itemArray = [items]()
    
    init(data:[String:Any]) {
        name = data["name"] as? String ?? ""
        let item = data["items"] as? [[String:Any]] ?? []
        for i in item {
            itemArray.append(items(data:i))
        }
    }
}

struct items {
    
    var has_toppings : Bool!
    var id : Int!
    var name : String!
    var price : Int!
    var category_id : Int!
    var is_out_of_stock : Bool!
    var tbl_item_toppings = [itemToppings]()
    var description : String!
    var itemCount : Int!
    var tax : String!
    
    init(data:[String:Any]) {
        has_toppings = data["has_toppings"] as? Bool ?? false
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        description = data["description"] as? String ?? ""
        price = data["price"] as? Int ?? 0
        category_id = data["category_id"] as? Int ?? 0
        is_out_of_stock = data["is_out_of_stock"] as? Bool ?? false
        itemCount = 1
        tax = data["Tax"] as? String ?? "0.00"
        let itemTop = data["tbl_item_toppings"] as? [[String:Any]] ?? []
        for i in itemTop {
            tbl_item_toppings.append(itemToppings(data:i))
        }
    }
}

struct itemToppings {
    
    var id : Int!
    var name : String!
    var item_id : Int!
    var price : Int!
    var isSelected : Bool!
    var topping_tax : Double!
    
    init(data:[String:Any]){
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        item_id = data["item_id"] as? Int ?? 0
        price = data["price"] as? Int ?? 0
        isSelected = false
        topping_tax = data["topping_tax"] as? Double ?? 0.00
    }
}

struct questions {
    
    var id : Int?
    var question_1 : String?
    var question_2 : String?
    var question_3 : String?
    var question_4 : String?
    var question_5 : String?
    var business_id : Int?
    var resort_id : Int?
    
    init(data:[String:Any]) {
        id = data["id"] as? Int ?? 0
        question_1 = data["question_1"] as? String ?? ""
        question_2 = data["question_2"] as? String ?? ""
        question_3 = data["question_3"] as? String ?? ""
        question_4 = data["question_4"] as? String ?? ""
        question_5 = data["question_5"] as? String ?? ""
        business_id = data["business_id"] as? Int
        resort_id = data["resort_id"] as? Int
    }
}


struct locations {
    
    var id : Int?
    var location_name : String?
    var address : String?
    var business_id : Int?
    var resort_id : Int?
    
    init(data:[String:Any]) {
        id = data["id"] as? Int ?? 0
        location_name = data["location_name"] as? String ?? ""
        address = data["address"] as? String ?? ""
        business_id = data["business_id"] as? Int
        resort_id = data["resort_id"] as? Int
    }
}

struct hospitalityorderData {
    
    var id : Int!
    var contact_name : String!
    var status : String!
    var total_amount : Double!
    var tip : Double!
    var user_id : Int!
    var business_id : Int!
    var driver_id : Int!
    var delivery_type : Int!
    var order_date : String!
    var address : String!
    var name : String!
    var tbl_order_item_details = [[String:Any]]()
    var orderItem = [orderItems]()
    var ans1 : String!
    var ans2 : String!
    var ans3 : String!
    var ans4 : String!
    var ans5 : String!
    var que1 : String!
    var que2 : String!
    var que3 : String!
    var que4 : String!
    var que5 : String!
    var pickup_location = [String:Any]()
    
    init(data: [String:Any]) {
        id = data["id"] as? Int ?? 0
        contact_name = data["contact_name"] as? String ?? ""
        status = data["status"] as? String ?? ""
        total_amount = data["total_amount"] as? Double ?? 0.00
        user_id = data["user_id"] as? Int ?? 0
        business_id = data["business_id"] as? Int ?? 0
        driver_id = data["driver_id"] as? Int ?? 0
        delivery_type = data["delivery_type"] as? Int
        order_date = data["order_date"] as? String ?? ""
        address = data["address"] as? String ?? ""
        tip = data["tip"] as? Double ?? 0.00
        let tbl_business = data["tbl_business"] as? [String:Any] ?? [:]
        let tbl_resort = data["tbl_resort"] as? [String:Any] ?? [:]
        name = (tbl_resort["name"] as? String ?? "")  + " -> " + (tbl_business["name"] as? String ?? "")
        tbl_order_item_details = data["tbl_order_item_details"] as? [[String:Any]] ?? [[:]]
        for i in tbl_order_item_details {
            orderItem.append(orderItems(data: i))
        }
        let deliveryAnswers = data["tbl_order_delivery_answer"] as? [String:Any]
        if((deliveryAnswers) != nil){
            ans1 = deliveryAnswers!["question_1"] as? String ?? ""
            ans2 = deliveryAnswers!["question_2"] as? String ?? ""
            ans3 = deliveryAnswers!["question_3"] as? String ?? ""
            ans4 = deliveryAnswers!["question_4"] as? String ?? ""
            ans5 = deliveryAnswers!["question_5"] as? String ?? ""
         }
        let deliveryQuestions = data["tbl_delivery_question"] as? [String:Any]
        if((deliveryQuestions) != nil){
            que1 = deliveryQuestions!["question_1"] as? String ?? ""
            que2 = deliveryQuestions!["question_2"] as? String ?? ""
            que3 = deliveryQuestions!["question_3"] as? String ?? ""
            que4 = deliveryQuestions!["question_4"] as? String ?? ""
            que5 = deliveryQuestions!["question_5"] as? String ?? ""
        }
        let pickup_locations = data["tbl_pickup_location"] as? [String:Any] 
        if(pickup_locations != nil){
            pickup_location = pickup_locations!
        }
    }
}

struct orderItems {
    
    var item_id : Int!
    var order_id : Int!
    var order_item_details_id : Int!
    var price : Int!
    var quantity : Int!
    var itemName : String!
    var orderTopping = [orderToppings]()
    var topOrders = [[String:Any]]()
    
    init(data: [String:Any]) {

        item_id = data["item_id"] as? Int
        order_id = data["order_id"] as? Int
        order_item_details_id = data["order_item_details_id"] as? Int
        price = data["price"] as? Int
        quantity = data["quantity"] as? Int
        let itemNa = data["tbl_item"] as? [String:Any]
        itemName = itemNa!["name"] as? String
        topOrders = (data["tbl_order_toppings"] as? [[String:Any]])!
        for i in topOrders {
            orderTopping.append(orderToppings(data: i))
        }
    }
}

struct orderToppings {
    
    var id : Int!
    var price : Int!
    var toppingName : String!
    
    init(data : [String:Any]) {
        id = data["id"] as? Int
        price = data["price"] as? Int
        let topName = data["tbl_item_topping"] as? [String:Any]
        toppingName = topName!["name"] as? String
    }
}


struct hospitalityMessagesData {
    
    var id : Int!
    var message : String!
    var sender : Int!
    
    init(data: [String:Any]) {
        id = data["id"] as? Int ?? 0
        message = data["message"] as? String ?? ""
        sender = data["sender"] as? Int ?? 0
    }
}

struct hospitalityNotificationsData {
    
    var order_id : Int!
    var notification : String!
    var driver_id : Int!
    var type  : String!
    
    init(data: [String:Any]) {
        order_id = data["order_id"] as? Int ?? 0
        notification = data["message"] as? String ?? ""
        driver_id = data["driver_id"] as? Int ?? 0
        type = data["notification_type"] as? String ?? ""
    }
}
