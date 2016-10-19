//
//  CoreDataStack.swift
//  Virtual Tourist
//
//  Created by Andrew Olson on 9/19/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataStack {
    
    // MARK:  - Properties
    private let model : NSManagedObjectModel
    private let coordinator : NSPersistentStoreCoordinator
    private let modelURL : NSURL
    private let dbURL : NSURL
    let context : NSManagedObjectContext
    
    // MARK:  - Initializers
    init?(modelName: String){
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName) in the main bundle")
            return nil}
        
        self.modelURL = modelURL as NSURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else{
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // create a context and add connect it to the coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        
        
        // Add a SQLite store located in the documents folder
        let fm = FileManager.default
        
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.dbURL = docUrl.appendingPathComponent("model.sqlite") as NSURL
        let options = [NSInferMappingModelAutomaticallyOption : true,
                       NSMigratePersistentStoresAutomaticallyOption : true]
        
        do{
            try addStoreCoordinator(storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
            
        }catch{
            print("unable to add store at \(dbURL)")
        }
    
    }
    
    // MARK:  - Utils
    func addStoreCoordinator(storeType: String,
                             configuration: String?,
                             storeURL: NSURL,
                             options : [NSObject : AnyObject]?) throws{
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL as URL, options: nil)
        
    }
}




// MARK:  - Save
extension CoreDataStack {
    
    func saveContext() throws{
        if context.hasChanges {
            try context.save()
        }
    }
    
//    func autoSave(delayInSeconds : Int){
//        
//        if delayInSeconds > 0 {
//            do{
//                try saveContext()
//                print("Autosaving")
//            }catch{
//                print("Error while autosaving")
//            }
//            
//            
//            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
//            let time = DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delayInNanoSeconds))
//            
//            dispatch_after(time, dispatch_get_main_queue(), {
//                self.autoSave(delayInSeconds)
//            })
//            
//        }
//    }

}

