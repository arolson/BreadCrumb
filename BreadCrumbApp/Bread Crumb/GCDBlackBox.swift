//
//  GCDBlackBox.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
func performInBackGround(handler: @escaping () ->Void)
{
    DispatchQueue.global(qos: .userInitiated).async {
      handler()
    }
    //Swift 2 code
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
//    {
//        //Perform handler in background
//        handler()
//    }
}
