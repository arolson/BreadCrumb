//
//  Pin+CoreDataProperties.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/5/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var photos: [Photo]?
    @NSManaged var notes: Note?

}
