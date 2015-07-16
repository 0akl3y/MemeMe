//
//  CoreDataStack.swift
//  MemeMe
//
//  Created by Johannes Eichler on 16.07.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "MemeMe.sqlite"

class CoreDataStack {
    
    class func sharedObject() -> CoreDataStack{
        
        struct Static {
            
            static let instance = CoreDataStack()
        
        }
        
        return Static.instance
    }
    
    lazy var applicationDocumentDirectory: NSURL = {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls[urls.count - 1] as! NSURL
    
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
            let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
        
            return NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        }()
    
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        var coordinator:NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
            let url = self.applicationDocumentDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
            var error: NSError? = nil
        
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            
            // Left in for development development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator!
        
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let coordinator = self.persistentStoreCoordinator
        
        var context = NSManagedObjectContext()
        
        context.persistentStoreCoordinator = coordinator
        
        return context
    
    
    }()
    
    func saveContext(){
        
        var error:NSError? = nil
        
        if let context = self.managedObjectContext {
            
            if(context.hasChanges && !context.save(&error)){
                
                println("The context could not be saved: \(error)")
                
            }
        
        }
    
    
    }
    
    
   
}
