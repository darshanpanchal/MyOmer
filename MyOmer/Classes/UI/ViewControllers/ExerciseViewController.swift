//
//  ExerciseViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/7/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class ExerciseViewController: OmerChildBaseViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    var dayId:Int = 1
    var weekId:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        //add letf and right swipe gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    @IBAction func callSharing(sender: UIButton){
        if let exe = day?.exercise{
            let passStr = exe + "\n" + "\(Config.ShareView.text)"
            let activityVC = UIActivityViewController(
                activityItems: [
                    passStr
                ],
                applicationActivities: nil
            )
            self.present(activityVC, animated: true, completion: nil)
        }
    
        
    }
    @objc override func dayChanged(notification: NSNotification) {
        week = notification.userInfo!["week"]! as? OmerWeek
        day = notification.userInfo!["day"]! as? OmerDay
        if let _ = self.week,let _ = day{
            self.weekId = self.week!.id
            self.dayId = self.day!.day
        }
        refresh()
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                //PREVIOUS SELECTOR
                if (self.dayId != 1){
                    let numberOfPlaces = 7.0
                    var totalDays = Double(self.dayId)/numberOfPlaces
                    dayId -= 1
                    totalDays.round(.up)
                    self.weekId = Int(totalDays)
                    if (dayId) % 7 == 0 && weekId > 1 {
                        weekId -= 1
                    }
                    self.postDayChangeNotificationRequest()
                }else{
                    return
                }
                
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                //NEXT SELECTOR
                if(dayId == 49 || dayId <= OmerCalendar.getOmerCalendar().dayOfOmer){
                    let numberOfPlaces = 7.0
                    var totalDays = Double(self.dayId)/numberOfPlaces
                    totalDays.round(.up)
                    self.weekId = Int(totalDays)
                    dayId += 1
                    if (dayId - 1) % 7 == 0 {
                        weekId += 1
                    }
                    self.postDayChangeNotificationRequest()
                }else{
                    return
                }
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func postDayChangeNotificationRequest() {
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
            "day": day!,
            "tabIndex":0
            ])
    }
    // MARK: - Memory Cleanup Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ExerciseViewController {
    
    func refresh() {
        if let day = day {
            textLabel.text = day.exercise
        }
    }
}
