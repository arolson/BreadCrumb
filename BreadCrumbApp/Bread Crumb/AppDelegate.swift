//
//  AppDelegate.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/4/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        //Set the Status Bar to White
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        //customize the navigation Bars
        UINavigationBar.appearance().barTintColor = UIColor.appColor()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        do{
            try SharedData.stack!.saveContext()
        }catch{
            print("Error while saving.")
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        do{
            try SharedData.stack!.saveContext()
        }catch{
            print("Error while saving.")
        }
    }
}

