//
//  AppDelegate.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 23/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context: NSManagedObjectContext?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let container = persistentContainer(dbName: CONSTANTS.DBName) { (error: NSError) in
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        self.context = container.viewContext
        
        if(isFirstTime()){
            loadingViewController()
            JSONInteractor(manager: DownloadAsyncGCD()).execute(urlString: CONSTANTS.JsonUrl, context: context!) { (Void) in
                setAppLaunched()
                self.loadViewController()
            }
        }else{
            loadViewController()
        }
        
        return true
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    func loadingViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loadController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoadingController") 
        
        self.window?.rootViewController = loadController
    }
    
    func loadViewController(){
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        self.window?.rootViewController = navController
        
        self.injectContextAndFetchToFirstViewController()
        
        self.window?.makeKeyAndVisible()
        
    }
    
    func injectContextAndFetchToFirstViewController(){
        if let navController = window?.rootViewController as? UINavigationController,
            let initialViewController = navController.topViewController as? BooksViewController{
            initialViewController.context = self.context
            initialViewController.fetchedResultsController = BookTag.fetchController(context: context!, text: "")
        }
    }

}

