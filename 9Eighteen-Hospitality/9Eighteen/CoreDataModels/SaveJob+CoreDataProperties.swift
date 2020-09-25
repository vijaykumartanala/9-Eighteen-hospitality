//
//  Student+CoreDataProperties.swift
//  IEPOneApp
//
//  Created by Kumar, Sravan on 23/09/18.
//  Copyright © 2018 Shivaji Yerra. All rights reserved.
//
//

import Foundation
import CoreData

extension CartData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartData> {
        return NSFetchRequest<CartData>(entityName: "CartData")
    }
    @NSManaged public var categoryName: String?
    @NSManaged public var foodDesc: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var itemId: String?
    @NSManaged public var itemNote: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var psteligible: String?
    @NSManaged public var quantity: String?
    @NSManaged public var tax: String?
    @NSManaged public var sectionId: String?
}


 extension HospitalityCartData {
    
   @nonobjc public class func fetchRequest() -> NSFetchRequest<HospitalityCartData> {
        return NSFetchRequest<HospitalityCartData>(entityName: "HospitalityCartData")
    }
    @NSManaged public var delivery_type: String?
    @NSManaged public var bussiness_name: String?
    @NSManaged public var bussiness_imageurl: String?
    @NSManaged public var bussiness_id: String?
    @NSManaged public var tax: String?
    @NSManaged public var category_id: String?
    @NSManaged public var id: String?
    @NSManaged public var itemCount: String?
    @NSManaged public var itemdescription: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var topping_id: String?
    @NSManaged public var topping_item_id: String?
    @NSManaged public var topping_name: String?
    @NSManaged public var topping_price: String?
}
