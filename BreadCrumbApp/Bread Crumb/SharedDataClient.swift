//
//  Context.swift
//  VirtualTourist
//
//  Created by Andrew Olson on 9/28/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit
import CoreData

class SharedData
{
    static let stack = CoreDataStack(modelName:  "Model")
    
    class func getContext()-> NSManagedObjectContext
    {
        return stack!.context
    }
    private init(){}
}
