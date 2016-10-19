//
//  Note.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/5/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import Foundation
import CoreData


class Note: NSManagedObject {

    convenience init(text: String, context: NSManagedObjectContext) {
//        if let ent = NSEntityDescription.entity(forEntityName: "Note", in: context) {
//            self.init(entity: ent, insertIntoManagedObjectContext: context)
//            
//            self.text = text
//            print("Note Created")
//        } else {
//            fatalError("Unable to find Entity name!")
//        }
        if let ent = NSEntityDescription.entity(forEntityName: "Note", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.text = text
            print("Note Created")
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
