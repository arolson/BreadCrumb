//
//  Photo.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/5/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    convenience init(id: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.id = id
            print("Photo Created")
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
        
    }
}
