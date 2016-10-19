//
//  CoreDataViewController.swift
//  VirtualTourist
//
//  Created by Andrew Olson on 9/28/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController,NSFetchedResultsControllerDelegate
{
    let context = SharedData.getContext()
    
    var fetchedResultsController : NSFetchedResultsController<Pin>?{
        didSet{
            fetchedResultsController?.delegate = self
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController<Pin>) {
        fetchedResultsController = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func fetchPins()->[Pin]
    {
        let fetchRequest:NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true), NSSortDescriptor(key: "longitude", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Get the saved pins
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("There was an error fetching the list of pins.")
            return [Pin]()
        }
    }
    func fetchPhotos(pin: Pin)->[Photo]
    {
        let fetchRequest:NSFetchRequest<Photo> = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true), NSSortDescriptor(key: "imageData", ascending: false)]
        let predicate = NSPredicate(format: "pin = %@",argumentArray: [pin])
        fetchRequest.predicate = predicate
//         Get the saved pins
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("There was an error fetching the list of pins.")
            return [Photo]()
        }
    }
    func fetchNotes(pin: Pin)->[Note]
    {
        let fetchRequest:NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        let predicate = NSPredicate(format: "pin = %@",argumentArray: [pin])
        fetchRequest.predicate = predicate
        // Get the saved pins
        do {
            return try context.fetch(fetchRequest) 
        } catch {
            print("There was an error fetching the list of pins.")
            return [Note]()
        }
    }

    func save()
    {
        do {
            return try context.save()
        } catch {
            print("There was a problem While trying to save the Context")
        }
    }
    //    Core Data Pin deletion
    func deletePin(pin: Pin)
    {
        do
        {
            SharedData.getContext().delete(pin)
            try SharedData.getContext().save()
        }
        catch
        {
            print("Could Not Save Context")
        }
    }
}
