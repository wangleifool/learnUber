//
//  AppDelegate.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        showGuidePage()
        
        return true
    }
    
    func showGuidePage() {
        let guidePage = WLGuidePageViewController()
        self.window?.rootViewController = guidePage
        self.window?.makeKeyAndVisible()
    }
    
    func showHomePage() {
        
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            
            self.createHomePage()
            
        }, completion: nil)
        
        
    }
    
    func createHomePage() {
        let mainViewController   = WLHomePageViewController()
        let drawerViewController = DrawerViewController()
        let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: ScreenWidth*270/320)
        drawerController.mainViewController = UINavigationController(
            rootViewController: mainViewController
        )
        drawerController.drawerViewController = drawerViewController
        
        /* Customize
         drawerController.drawerDirection = .Right
         drawerController.drawerWidth     = 200
         */
        
        addMap() //添加百度地图服务
        
        window?.rootViewController = drawerController

    }
    
    func addMap() {
        mapManager = BMKMapManager()
        let ret = mapManager?.start("ufMFSlns6SQoTKsIXYgRURpIrFoqbNql", generalDelegate: nil)
        if !ret! {
            print("start baidu map service fail")
        }
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
    }


}

