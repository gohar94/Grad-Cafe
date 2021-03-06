//
//  AppDelegate.swift
//  Grad Cafe
//
//  Created by Gohar Irfan on 2/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var askQuery = true
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupRootViewController(false)
        return true
    }
    
    func setupRootViewController(animated: Bool) {
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            
            // create and setup appropriate rootViewController
            if askQuery {
                let loginViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("queryVC") as! QueryVC
                newRootViewController = loginViewController
                transition = .TransitionFlipFromLeft
                
            } else {
                let splitViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("splitVC") as! UISplitViewController
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                splitViewController.delegate = self
                newRootViewController = splitViewController
                transition = .TransitionFlipFromRight
            }
            
            // update app's rootViewController
            if let rootVC = newRootViewController {
                if animated {
                    UIView.transitionWithView(window, duration: 0.5, options: transition, animations: { () -> Void in
                        window.rootViewController = rootVC
                        }, completion: nil)
                } else {
                    window.rootViewController = rootVC
                }
            }
        }
    }

//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Override point for customization after application launch.
//        let splitViewController = self.window!.rootViewController as! UISplitViewController
//        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
//        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
//        splitViewController.delegate = self
//        return true
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

