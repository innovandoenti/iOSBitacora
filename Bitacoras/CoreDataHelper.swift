//
//  CoreDataHelper.swift
//  SwiftCoreDataSimpleDemo
//
//  Created by CHENHAO on 14-6-7.
//  Copyright (c) 2014 CHENHAO. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject{
    
   
    
    var store: CoreDataStack!
    
    override init(){
        // all CoreDataHelper share one CoreDataStore defined in AppDelegate
        super.init()
        if  let appDelegate =  UIApplication.shared.delegate as? AppDelegate{
            self.store = appDelegate.cdstore
            NotificationCenter.default.addObserver(self, selector: #selector(CoreDataHelper.contextDidSaveContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    // #pragma mark - Core Data stack
    
    // main thread context
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // Returns the background object context for the application.
    // You can use it to process bulk data update in background.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    
    // save NSManagedObjectContext
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
                abort()
            }
        }
    }
    
   func saveContext () {
        self.saveContext( context: self.backgroundContext! )
    }
    
    // call back function by saveContext, support multi-thread
    @objc func contextDidSaveContext(notification: NSNotification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            NSLog("******** Saved main Context in this thread")
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification as Notification)
            }
        } else if sender === self.backgroundContext {
            NSLog("******** Saved background Context in this thread")
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
            }
        } else {
            NSLog("******** Saved Context in other thread")
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification as Notification)
            }
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
            }
        }
    }
}
