//
//  AppDelegate.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2017-09-11.
//  Copyright © 2017 Nick Fournier. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Players")
        
        var returnedPlayers: [NSManagedObject] = []
        do {
            returnedPlayers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if returnedPlayers.count == 0 {
            savePlayerTable()
        }
        
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Players")
        
        var returnedPlayers2: [NSManagedObject] = []
        do {
            returnedPlayers2 = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for player in returnedPlayers2 {
            let thisPlayer = player as! Players
            print(thisPlayer.playerName!)
            print(thisPlayer.goals)
            print(thisPlayer.assists)
        }
        print(returnedPlayers2.count)
        
        
        
        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Draft Assist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func savePlayerTable(){
        CSVScanner.runFunctionOnRowsFromFile(theColumnNames: ["playerName", "goals", "assists", "pim", "ppp", "shp", "gwg", "blocks", "hits", "round"], withFileName: "DraftAssist", withFunction: {(aRow:Dictionary<String, String>) in
            
            let managedContext = self.persistentContainer.viewContext
            
            let playerEntity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)!
            let player = NSManagedObject(entity: playerEntity, insertInto: managedContext) as! Players
            
            player.playerName = aRow["playerName"]
            player.goals = Int32(aRow["goals"]!) ?? -1
            player.assists = Int32(aRow["assists"]!) ?? -1
            player.pim = Int32(aRow["pim"]!) ?? -1
            player.ppp = Int32(aRow["ppp"]!) ?? -1
            player.shp = Int32(aRow["shp"]!) ?? -1
            player.gwg = Int32(aRow["gwg"]!) ?? -1
            player.blocks = Int32(aRow["blocks"]!) ?? -1
            player.hits = Int32(aRow["hits"]!) ?? -1
            
            // save locally
            do {
                try managedContext.save()
                DispatchQueue.main.async {
                    print("Imported players to core data")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error importing notes to core data")
                }
                return
            }
        })
    }
    
}

