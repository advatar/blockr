//
//  CoreDataStorage.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/18/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import CoreData

open class CoreDataReadOnlyStorage {
	
	// MARK: - Shared Instance
	
	public static let sharedInstance = CoreDataReadOnlyStorage()
	
	// MARK: - Core Data stack
	
	lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named 'Bundle identifier' in the application's documents Application Support directory.
		let urls = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count-1]
	}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: "callblocker", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let options = [
            NSReadOnlyPersistentStoreOption: true
        ]
		let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.carechain.CallBlocker")!
		let url = directory.appendingPathComponent("callblocker.sqlite")
		do {
			try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
		} catch var error as NSError {
			coordinator = nil
			NSLog("Unresolved error \(error), \(error.userInfo)")
			abort()
		} catch {
			fatalError()
		}
		return coordinator
	}()
	
	// MARK: - NSManagedObject Contexts
	
	open class func mainQueueContext() -> NSManagedObjectContext {
		return self.sharedInstance.mainQueueCtxt!
	}
	
	open class func privateQueueContext() -> NSManagedObjectContext {
		return self.sharedInstance.privateQueueCtxt!
	}
	
	lazy var mainQueueCtxt: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		var managedObjectContext = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
		return managedObjectContext
	}()
	
	lazy var privateQueueCtxt: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		var managedObjectContext = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
		return managedObjectContext
	}()

}
