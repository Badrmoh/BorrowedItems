//
//  CoreDataHelper.swift
//  BorrowedItems
//
//  Created by Badr  on 17/01/2017.
//  Copyright © 2017 Badr. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    class func managedObjectContext () -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    class func insertManagedObject(name: NSString, managedObjectContext: NSManagedObjectContext) -> AnyObject {
        
        return NSEntityDescription.insertNewObject(forEntityName: name as String, into: managedObjectContext)
    }
    
    class func fetchEntities (name: NSString, managedObjectContext: NSManagedObjectContext, sortDescriptor:NSSortDescriptor?, predicate: NSPredicate?) -> NSArray {
        let request = NSFetchRequest<NSManagedObject>()
        let entityDescription = NSEntityDescription.entity(forEntityName: name as String, in: managedObjectContext)
        request.entity = entityDescription
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        var items = [NSManagedObject]()
        
        do {
            try items = managedObjectContext.fetch(request)
        } catch {
            fatalError("\(error)")
        }
        
        return items as NSArray
    }
    
}
