//
//  AppDelegate.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/18/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit

let kNotificationAppWillEnterForeground = "kNotificationAppWillEnterForeground"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        addSomeInitialValues()
        return true
    }
    
    private func addSomeInitialValues(){ // just for demo
        //add initial blocked and suspicious numbers
        guard isFirstTimeStart() else {return}
        
        let ctx = CoreDataStorage.privateQueueContext()
        ctx.performAndWait {
            // add some blocked numbers
            _ = PhoneNumber.createOrUpdate(number: 1_253_950_1212, desc: nil, type: .blocked, ctx: ctx)
            
            // add some suspicious numbers
            _ = PhoneNumber.createOrUpdate(number: 1_425_950_1212, desc: "Political Robocalls", type: .suspicious, ctx: ctx)
            do {
                try ctx.save()
            } catch {
                print("Ctx save exception: \(error)")
            }
        }
    }
    
    private func isFirstTimeStart() -> Bool {
        let alreadyStarted = UserDefaults.standard.bool(forKey: "kAlreadyStarted")
        if !alreadyStarted {
            UserDefaults.standard.set(true, forKey: "kAlreadyStarted")
            return true
        }
        return false
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(kNotificationAppWillEnterForeground), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let context = CoreDataStorage.mainQueueContext()
        CoreDataStorage.saveContext(context)
    }


}

