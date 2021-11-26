//
//  OmerContainerViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/6/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import LGSideMenuController
import Firebase

class OmerContainerViewController: UIViewController, HomeviewDelegate {
    
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    var child: UIViewController?
    var weekId = 1
    var currentDayId:Int = 1
    var dayId:Int{
        get{
              return currentDayId
        }
        set{
            self.currentDayId = newValue
            //configure currentday
            print("===== current day id \(currentDayId) ======")
              print("===== current Tab IUndex id \(tabIndex) ======")
          
        }
    }
    var weeks = [
        (OmerWeek(week: 1), false),
        (OmerWeek(week: 2), false),
        (OmerWeek(week: 3), false),
        (OmerWeek(week: 4), false),
        (OmerWeek(week: 5), false),
        (OmerWeek(week: 6), false),
        (OmerWeek(week: 7), false)
    ]
    fileprivate var week: OmerWeek?
    fileprivate var day: OmerDay?
    fileprivate let calendar = OmerCalendar.getOmerCalendar()
    
    var tabIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let child = child {
            if let homeVc:HomeViewController = self.child as? HomeViewController{
                homeVc.delegate = self
                
            }
            addChild(child)
            containerView.addSubview(child.view)
            child.view.frame = containerView.bounds
            child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            child.didMove(toParent: self)
            self.child = nil
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .omerDayChanged, object: nil)
        
        week = OmerWeek(week: weekId)
        day = OmerDay(day: dayId)
       
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": weekId,
            "week": week!,
            "dayId": dayId,
            "day": day!
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        print(dayId)
        self.configureNextAndPreviousSelector()

        if dayId == 49 || dayId >= calendar.dayOfOmer {
          //  self.nextButton.isEnabled = false
            return
        }
    }
    
    func dayChangeDelegate(objWeek:OmerWeek){
        DispatchQueue.main.async {
            self.titleLabel.text = objWeek.title
            self.subtitleLabel.text = objWeek.subtitle
            self.view.backgroundColor = objWeek.primaryColor
        }
        
        /*
        print(objParameters)
        if let objweekId = objParameters["weekId"] as? Int{
            self.weekId = objweekId
        }
        if let objweeks = objParameters["week"] as? OmerWeek{
            week = objweeks
            DispatchQueue.main.async {
                print(objweeks.title)
                self.titleLabel.text = objweeks.title
                self.subtitleLabel.text = objweeks.subtitle
                self.view.backgroundColor = objweeks.primaryColor
            }
        }
        if let objdayId = objParameters["dayId"] as? Int{
            dayId = objdayId
        }
        if let objdays = objParameters["day"] as? OmerDay{
            day = objdays
        }
        */
        self.refresh()
    }
    func indexChanged(index: Int,dayID:Int) {
        //Crashlytics.sharedInstance().crash()
        if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
            if index == 0{
                Analytics.logEvent("User_Access_Daily", parameters:["Email":"\(userEmail)"])
            }else if index == 1{
                Analytics.logEvent("User_Access_Weekly", parameters:["Email":"\(userEmail)"])
            }else{
                Analytics.logEvent("User_Access_Blessing", parameters:["Email":"\(userEmail)"])
            }
        }
        self.tabIndex = index
        if self.tabIndex == 0{
            self.dayId = dayID
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
            let numberOfPlaces = 7.0
            var totalDays = Double(dayId)/numberOfPlaces
            totalDays.round(.up)
//            totalDays += 1.0
            let numberWeek = Int(totalDays)
            self.weekId = numberWeek
            self.configureNextAndPreviousSelector()
            
        }else if self.tabIndex == 1{
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
            let numberOfPlaces = 7.0
            var totalDays = Double(totalDay)/numberOfPlaces
            totalDays.round(.up)
//            totalDays += 1.0
            let numberWeek = Int(totalDays)
            
            self.previousButton.isEnabled = (self.weekId != 1)
            self.nextButton.isEnabled = !(self.weekId == numberWeek)
        }else if self.tabIndex == 2{
            self.dayId = dayID
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
            let numberOfPlaces = 7.0
            var totalDays = Double(dayId)/numberOfPlaces
            totalDays.round(.up)
//            totalDays += 1.0
            let numberWeek = Int(totalDays)
            self.weekId = numberWeek
            self.configureNextAndPreviousSelector()
        }else{
            
        }
        guard dayId < 50 else{
            return
        }
        guard weekId < 8 else{
            return
        }
        week = OmerWeek(week: weekId)
        day = OmerDay(day: dayId)
        
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": weekId,
            "week": week!,
            "dayId": dayId,
            "day": day!
            ])
        
    }
    @objc func dayChanged(notification: NSNotification) {
        
        weekId = notification.userInfo!["weekId"] as! Int
        week = notification.userInfo!["week"]! as? OmerWeek
        dayId = notification.userInfo!["dayId"] as! Int
        day = notification.userInfo!["day"]! as? OmerDay
        
        day = OmerDay.init(day: dayId)
       
        refresh()
        
        
        if  let tabIndex =  notification.userInfo!["tabIndex"] as? Int{
            self.tabIndex = tabIndex
            if tabIndex == 0{ //Day
                self.configureNextAndPreviousSelector()
            }else if tabIndex == 1{ //Week
                var totalDay:Int = 0
                for objWeek in self.weeks{
                    totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
                }
                let numberOfPlaces = 7.0
                var totalDays = Double(totalDay)/numberOfPlaces
                totalDays.round(.up)
//                totalDays += 1.0
                let numberWeek = Int(totalDays)
                self.nextButton.isEnabled =  self.weekId < numberWeek//self.weekId > 1
                self.previousButton.isEnabled = (self.weekId != 1)
                
            }else if tabIndex == 2{ // Blessings
                self.configureNextAndPreviousSelector()
            }
        }
    }

    func configureNextAndPreviousSelector(){
        if let _ = self.previousButton,let _ = self.nextButton{
            self.previousButton.isEnabled = (self.dayId != 1)
            self.nextButton.isEnabled =  !(dayId == 49 || dayId >= calendar.dayOfOmer)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OmerContainerViewController {
    
    @IBAction func menuButton_Pressed(_ sender: Any) {
        let sideMenu = view.window?.rootViewController as! LGSideMenuController
        sideMenu.showLeftViewAnimated()
    }
    
    @IBAction func nextButton_Pressed(_ sender: Any) {
        
//        dayId += 1
//        if (dayId - 1) % 7 == 0 {
//            weekId += 1
//        }
        if self.tabIndex == 0{
            if(dayId == 49 || dayId <= calendar.dayOfOmer){
                dayId += 1
                if (dayId - 1) % 7 == 0 {
                    weekId += 1
                }
            }
            self.configureNextAndPreviousSelector()
           
        }else if self.tabIndex == 1{
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
             let numberOfPlaces = 7.0
            var totalDays = Double(totalDay)/numberOfPlaces
            totalDays.round(.up)
            totalDays += 1.0
            var numberWeek = Int(totalDays)
//            numberWeek += 1
            if self.weekId < numberWeek{
                weekId += 1
            }
            self.nextButton.isEnabled =  self.weekId < numberWeek//self.weekId > 1
            self.previousButton.isEnabled = (self.weekId != 1)
            
        }else if self.tabIndex == 2{
            if(dayId == 49 || dayId <= calendar.dayOfOmer){
                dayId += 1
                if (dayId - 1) % 7 == 0 {
                    weekId += 1
                }
            }
            self.configureNextAndPreviousSelector()
        }else{
            
        }
        
//        print(dayId)
//        print(calendar.dayOfOmer)
//        if dayId == 49 || dayId >= calendar.dayOfOmer {
//           // self.nextButton.isEnabled = false
//            return
//        }
//
       
       
        week = OmerWeek(week: weekId)
        
        day = OmerDay(day: dayId)
        
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": weekId,
            "week": week!,
            "dayId": dayId,
            "day": day!,
            "tabIndex":self.tabIndex
        ])
        
        refresh()
    }
    
    @IBAction func previousButton_Pressed(_ sender: Any) {
        
//        dayId -= 1
//        if (dayId) % 7 == 0 && weekId > 1 {
//            weekId -= 1
//        }
        if self.tabIndex == 0{
            if (self.dayId != 1){
                dayId -= 1
                if (dayId) % 7 == 0 && weekId > 1 {
                    weekId -= 1
                }
            }
            self.configureNextAndPreviousSelector()
           
        }else if self.tabIndex == 1{
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
            let numberOfPlaces = 7.0
            var totalDays = Double(totalDay)/numberOfPlaces
            totalDays.round(.up)
            totalDays += 1.0
            var numberWeek = Int(totalDays)
//            numberWeek += 1
            if (self.weekId != 1){
                weekId -= 1
            }
            self.nextButton.isEnabled =  self.weekId < numberWeek//self.weekId > 1
            self.previousButton.isEnabled = (self.weekId != 1)
            
        }else if self.tabIndex == 2{
            if (self.dayId != 1){
                dayId -= 1
            }
            if (dayId) % 7 == 0 && weekId > 1 {
                weekId -= 1
            }
            self.configureNextAndPreviousSelector()
           
        }else{
            
        }

//        if dayId == 1 {
//            return
//        }
//        
//        dayId -= 1
//        if (dayId) % 7 == 0 && weekId > 1 {
//            weekId -= 1
//        }
        week = OmerWeek(week: weekId)
        day = OmerDay(day: dayId)
        
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": weekId,
            "week": week!,
            "dayId": dayId,
            "day": day!,
            "tabIndex":self.tabIndex
            
        ])
        
        refresh()
    }
}


extension OmerContainerViewController {
    
    func refresh() {
        if let week = week {
            titleLabel.text = week.title
            subtitleLabel.text = week.subtitle
            view.backgroundColor = week.primaryColor
//            guard let currentView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view,
//                let superview = currentView.superview else { return }
//            UITabBar.appearance().tintColor = week.primaryColor
//            UITabBar.appearance().backgroundColor = UIColor.lightGray
//           
//            currentView.removeFromSuperview()
//            superview.addSubview(currentView)
        }
    }
}
