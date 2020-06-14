//
//  AppDelegate.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import SideMenuSwift

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootVC : UIViewController!
    var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY)
        appearanceSetup()
        setRootViewController()
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "YagnikPractical_Z")
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

}

extension AppDelegate {
    private func appearanceSetup() {
        UINavigationBar.appearance().barTintColor = .appGreen
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: AppFont.sfUIDisplaybold.getFont(withSize: 18)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: AppFont.sfUIDisplaybold.getFont(withSize: 34)]
        UINavigationBar.appearance().backIndicatorImage = "ic_back".imageWithTemplatedMode
        UINavigationBar.appearance().tintColor = .appGreen
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = "ic_back".imageWithTemplatedMode
        UIToolbar.appearance().barTintColor = .appGreen
        UIToolbar.appearance().isTranslucent = false
        UIToolbar.appearance().tintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        setupSideMenu()
    }
    
    private func setupSideMenu() {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.size.width * 0.8
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = false
        SideMenuController.preferences.basic.enablePanGesture = true
    }
    
    private func setRootViewController() {
        let homeNavVC = HomeNavigationController.instantiateFromStoryboard()
        let menuVC = MenuController.instantiateFromStoryboard()
        let sideMenuVC = SideMenuController(contentViewController: homeNavVC, menuViewController: menuVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = sideMenuVC
        window?.makeKeyAndVisible()
    }
}
