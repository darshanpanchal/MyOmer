//
//  AppDelegate.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 1/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import UserNotifications
import LGSideMenuController
import INTULocationManager
import SwiftySunrise
import Firebase
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var isSetNextDay:Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)

        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.lightGray
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        var newArguments = ProcessInfo.processInfo.arguments
        newArguments.append("-FIRDebugEnabled")
        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        center.requestAuthorization(options: options) { (granted, error) in
            
        }
        let defaults = UserDefaults.standard
        let languageId = defaults.integer(forKey: "blessing.language")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            startup()
        } else {
            let emailOmerVC = storyboard.instantiateViewController(withIdentifier: "EmailAuthenticationViewController") as! EmailAuthenticationViewController
            window?.rootViewController = emailOmerVC
        }
        // startup()
        Analytics.logEvent("User_Launch_App", parameters:[:])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
         UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        startup()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

extension AppDelegate {
    
    func startup() {
        
        let calendar = OmerCalendar.getOmerCalendar()
        let notificationsManager = NotificationsManager(calendar: calendar)
        notificationsManager.scheduleNotifications()
        
        //UIApplication.shared.cancelAllLocalNotifications()
        if calendar.status == .comingUpCurrentYear || calendar.status == .comingUpNextYear {
            UIApplication.shared.applicationIconBadgeNumber = 0
            setupWaiting(calendar: calendar)
        }
        else {
            
            setupMain(calendar: calendar)
        }
//        let app: UIApplication = UIApplication.shared
//        for oneEvent in app.scheduledLocalNotifications! {
//            print("oneEvent Deleted ======================= \(oneEvent)")
//            let notification = oneEvent as UILocalNotification
//            app.cancelLocalNotification(notification)
//            
//        }
    }
    
    func setupWaiting(calendar: OmerCalendar) {
        
       
        let waitingOmerVC = storyboard.instantiateViewController(withIdentifier: "WaitingOmerViewController") as! WaitingOmerViewController
        waitingOmerVC.omerCalendar = calendar
        window?.rootViewController = waitingOmerVC
    }
    
    func setupMain(calendar: OmerCalendar) {
        
        var weekId = calendar.dayOfOmer / 7 + 1
        if weekId > 7 {
            weekId = 7
        }
        let dayId = calendar.dayOfOmer
        print(dayId)
        UIApplication.shared.applicationIconBadgeNumber = OmerBlessingRecord.pendingBlessings(until: dayId)
        
        // For testing.
        //let weekId = 1
        //let dayId = 1
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let journalViewController = sb.instantiateViewController(withIdentifier: "JournalViewController") as! JournalViewController
        let exerciseViewController = sb.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
        let videoViewController = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        
        let homeContainer = sb.instantiateViewController(withIdentifier: "OmerContainerViewController") as! OmerContainerViewController
        homeContainer.child = homeViewController
        homeContainer.title = "HOME"
        homeContainer.weekId = weekId
        homeContainer.dayId = dayId
        homeContainer.loadViewIfNeeded()
        
        let journalContainer = sb.instantiateViewController(withIdentifier: "OmerContainerViewController") as! OmerContainerViewController
        journalContainer.child = journalViewController
        journalContainer.title = "JOURNAL"
        journalContainer.weekId = weekId
        journalContainer.dayId = dayId
        journalContainer.loadViewIfNeeded()
        
        let exerciseContainer = sb.instantiateViewController(withIdentifier: "OmerContainerViewController") as! OmerContainerViewController
        exerciseContainer.child = exerciseViewController
        exerciseContainer.title = "EXERCISE"
        exerciseContainer.weekId = weekId
        exerciseContainer.dayId = dayId
        exerciseContainer.loadViewIfNeeded()
        
        let videoContainer = sb.instantiateViewController(withIdentifier: "OmerContainerViewController") as! OmerContainerViewController
        videoContainer.child = videoViewController
        videoContainer.title = "VIDEO"
        videoContainer.weekId = weekId
        videoContainer.dayId = dayId
        videoContainer.loadViewIfNeeded()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeContainer,
            journalContainer,
            exerciseContainer,
            videoContainer
        ]
        tabBarController.delegate = self
        tabBarController.tabBar.items![0].image = UIImage(named: "home_icon")
        tabBarController.tabBar.items![0].selectedImage = UIImage(named: "home_icon")
        tabBarController.tabBar.items![1].image = UIImage(named: "journal_icon")
        tabBarController.tabBar.items![1].selectedImage = UIImage(named: "journal_icon")
        tabBarController.tabBar.items![2].image = UIImage(named: "exercise_icon")
        tabBarController.tabBar.items![2].selectedImage = UIImage(named: "exercise_icon")
        tabBarController.tabBar.items![3].image = UIImage(named: "video_icon")
        tabBarController.tabBar.items![3].selectedImage = UIImage(named: "video_icon")
        
        let rootVC = sb.instantiateViewController(withIdentifier: "EntryPoint") as! LGSideMenuController
        rootVC.rootViewController = tabBarController
        window?.rootViewController = rootVC
    }    
}
extension AppDelegate:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let omerView = viewController as? OmerContainerViewController,let homeVC = omerView.children.first! as? HomeViewController{
            homeVC.configureFirstTab()
        }
        if let omerView = viewController as? OmerContainerViewController{
            if let _ = omerView.children.first! as? HomeViewController{
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                        Analytics.logEvent("User_Access_Home", parameters:["Email":"\(userEmail)"])
                }
            }else if let  _ = omerView.children.first! as? JournalViewController{
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                    Analytics.logEvent("User_Access_Journal", parameters:["Email":"\(userEmail)"])
                }
            }else if let _ = omerView.children.first! as? ExerciseViewController{
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                    Analytics.logEvent("User_Access_Exercise", parameters:["Email":"\(userEmail)"])
                }
            }else if let _ = omerView.children.first! as? VideoViewController{
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                    Analytics.logEvent("User_Access_Video", parameters:["Email":"\(userEmail)"])
                }
            }
        }
    }
}
extension Notification.Name {
    static let omerDayChanged = Notification.Name("omerDayChanged")
}


