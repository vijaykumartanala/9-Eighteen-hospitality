//
//  Student+CoreDataClass.swift
//  IEPOneApp
//
//  Created by Kumar, Sravan on 17/09/18.
//  Copyright © 2018 Shivaji Yerra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CartData)
public class CartData: NSManagedObject {
    
    public func CartData(cart cartDetails: [String: String]) {
        categoryName = cartDetails["categoryName"] ?? ""
        foodDesc = cartDetails["foodDesc"] ?? ""
        imageUrl = cartDetails["imageUrl"] ?? ""
        itemId = cartDetails["itemId"] ?? ""
        itemNote = cartDetails["itemNote"] ?? "   type message here..."
        name = cartDetails["name"] ?? ""
        price = cartDetails["price"] ?? ""
        psteligible = cartDetails["psteligible"] ?? ""
        quantity = cartDetails["quantity"] ?? ""
        tax = cartDetails["tax"] ?? ""
        sectionId = cartDetails["sectionId"] ?? ""
        CoreDataStack.shared.saveContext()
    }
    
    public static func fetchCartDetails() -> [CartData] {
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        var results: [CartData] = []
        do {
            results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            return results
        } catch  _ {
            print("error: \(#function)")
        }
        return results
    }
    
    public static func getItemsCount() -> Int {
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        let count = try! CoreDataStack.shared.persistentContainer.viewContext.count(for: request)
        return count
    }
    
    public static func fetchGoals(goalID:String,quantity : String) {
        let predicate = NSPredicate(format: "itemId = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            results.first!.setValue(quantity, forKeyPath: "quantity")
            CoreDataStack.shared.saveContext()
        }catch  _ {
            print("error: \(#function)")
        }
    }
    
    public static func deleteObj(goalID:String) {
        let predicate = NSPredicate(format: "itemId = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                CoreDataStack.shared.persistentContainer.viewContext.delete(i)
            }
            CoreDataStack.shared.saveContext()
        } catch  _ {
            print("error: \(#function)")
        }
    }
    
    public static func exits(goalID:String) -> Bool {
        let predicate = NSPredicate(format: "itemId = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                if goalID == i.itemId! {
                    return true
                }
            }
            return false
        } catch  _ {
            print("error: \(#function)")
        }
        return false
    }
    
    public static func bussinessexits(goalID:String) -> Bool {
        let predicate = NSPredicate(format: "psteligible = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                if goalID == i.psteligible! {
                    return true
                }
            }
            return false
        } catch  _ {
            print("error: \(#function)")
        }
        return false
    }
    
    public static func menusectionexits(goalID:String) -> Bool {
           let predicate = NSPredicate(format: "sectionId = %@ ", goalID as CVarArg)
           let request = NSFetchRequest<CartData>(entityName: "CartData")
           request.returnsObjectsAsFaults = false
           request.predicate = predicate
           do {
               let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
               for i in results {
                   if goalID == i.sectionId!{
                       return true
                   }
               }
               return false
           } catch  _ {
               print("error: \(#function)")
           }
           return false
       }
    
    public static func updateData(goalID:String,quantity:Int) {
        let predicate = NSPredicate(format: "itemId = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                if goalID == i.itemId! {
                    i.setValue(String(Int(i.quantity!)! + quantity), forKey: "quantity")
                }
            }
            CoreDataStack.shared.saveContext()
        } catch  _ {
            print("error: \(#function)")
        }
    }
}



@objc(HospitalityCartData)
public class HospitalityCartData: NSManagedObject {
    
//MARK:- Relelations db Functions
    public static func fetchItemDetails() -> [HospitalityItems] {
        let request = NSFetchRequest<HospitalityItems>(entityName: "HospitalityItems")
        var results = [HospitalityItems]()
        do {
            results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            return results
        }catch  _ {
            print("error: \(#function)")
        }
        return results
    }
    
 //MARK: Toppings Get Apis
    public static func fetchToppingDetails(item_id:Int16) -> [ItemsToppings] {
           let predicate = NSPredicate(format: "item_id = \(item_id)")
           let request = NSFetchRequest<ItemsToppings>(entityName: "ItemsToppings")
           request.returnsObjectsAsFaults = false
           request.predicate = predicate
           var results = [ItemsToppings]()
           do {
               results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
               return results
           }catch  _ {
               print("error: \(#function)")
           }
           return results
       }
    
     public static func getToppingsCount() -> Int {
           let request = NSFetchRequest<HospitalityItems>(entityName: "HospitalityItems")
           let count = try! CoreDataStack.shared.persistentContainer.viewContext.count(for: request)
           return count
       }
    
    public static func changeToppingsStatus(id:Int16) {
           let predicate = NSPredicate(format: "id = \(id)")
           let request = NSFetchRequest<ItemsToppings>(entityName: "ItemsToppings")
           request.returnsObjectsAsFaults = false
           request.predicate = predicate
           do {
               let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
                  if results.first?.is_selected == true{
                     results.first!.setValue(false, forKeyPath: "is_selected")
                    }else{
                     results.first!.setValue(true, forKeyPath: "is_selected")
                  }
               CoreDataStack.shared.saveContext()
           }catch  _ {
               print("error: \(#function)")
           }
       }
      
    
    public static func bussinessItemsIDExits(goalID:String) -> Bool {
        let predicate = NSPredicate(format: "bussiness_id = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<HospitalityItems>(entityName: "HospitalityItems")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                if goalID == String(i.bussiness_id) {
                    return true
                }
            }
            return false
        } catch  _ {
            print("error: \(#function)")
        }
        return false
    }
    
    public static func fetchOrderedItems(goalID:String,quantity : String) {
        let predicate = NSPredicate(format: "id = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<HospitalityItems>(entityName: "HospitalityItems")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            results.first!.setValue(Int(quantity) , forKeyPath: "itemCount")
            CoreDataStack.shared.saveContext()
        }catch  _ {
            print("error: \(#function)")
        }
    }
    
    public static func deleteOrderObj(goalID:String) {
        let predicate = NSPredicate(format: "id = %@ ", goalID as CVarArg)
        let request = NSFetchRequest<HospitalityItems>(entityName: "HospitalityItems")
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            for i in results {
                CoreDataStack.shared.persistentContainer.viewContext.delete(i)
            }
            CoreDataStack.shared.saveContext()
        } catch  _ {
            print("error: \(#function)")
        }
    }
}

