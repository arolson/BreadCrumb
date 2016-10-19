//
//  Pin.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/5/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        //old swift code
        /*if let ent = NSEntityDescription.entityforEntityName: inForName("Pin", inManagedObjectContext: context)
        {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.latitude = latitude as NSNumber?
            self.longitude = longitude as NSNumber?
            print("Pin Created")
        } else {
            fatalError("Unable to find Entity name!")
        }*/
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.latitude = latitude as NSNumber?
            self.longitude = longitude as NSNumber?
            print("Pin Created")
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
    

}
