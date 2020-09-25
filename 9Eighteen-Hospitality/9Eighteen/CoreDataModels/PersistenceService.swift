//
//  PersistenceService.swift
//  Saving Data BayBeh
//
//  Created by Kyle Lee on 7/2/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

//
//  CoreDataStack.swift
//  IEPOneApp
//
//  Created by Kumar, Sravan on 17/09/18.
//  Copyright © 2018 Shivaji Yerra. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let shared: CoreDataStack = CoreDataStack()
   
    
    private override init() {
        
    }
    
// MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(identifier: "com.9eighteen.NineEighteenReactUser")
        let modelURL = bundle?.url(forResource: "_Eighteen", withExtension: "momd")
        let modelObject = NSManagedObjectModel(contentsOf: modelURL!)
        
        let container = NSPersistentContainer(name: "_Eighteen", managedObjectModel: modelObject!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
// MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteContext() {
        let context = persistentContainer.viewContext
        do {
            let MovieData : [CartData] = try context.fetch(CartData.fetchRequest())
            for object in MovieData {
                context.delete(object)
            }
            self.saveContext()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
//MARK:- Relational db Functions
    func deleteOrderedItems() {
        let context = persistentContainer.viewContext
        do {
            let MovieData : [HospitalityItems] = try context.fetch(HospitalityItems.fetchRequest())
            for object in MovieData {
                context.delete(object)
            }
            self.saveContext()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}


