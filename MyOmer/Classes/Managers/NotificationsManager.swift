//
//  NotificationsManager.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 4/5/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsManager: NSObject {
    
    fileprivate let center = UNUserNotificationCenter.current()
    fileprivate var calendar: OmerCalendar
    
    init(calendar: OmerCalendar) {
        self.calendar = calendar
    }
    
    func scheduleNotifications() {
        
        center.removeAllPendingNotificationRequests()

        var count = 0
        for idx in 1...49 {
            var day: OmerDay?
            if idx == 50 {
                day = OmerDay(
                    day: 50,
                    week: 7,
                    dayOfWeek: 7,
                    quote: MultilingualText(
                        en: "",
                        es: "",
                        fr: "",
                        ru: "",
                        hb: ""
                    ),
                    sefirah: MultilingualText(
                        en: "",
                        es: "",
                        fr: "",
                        ru: "",
                        hb: ""
                    ),
                    title: "",
                    subtitle: "",
                    content: "",
                    exercise: "",
                    questions: []
                )
            }
            else {
                day = OmerDay(day: idx)
            }
            print(idx)
            let components = try! calendar.triggerComponents(for: idx)
            for component in components {
                if count < 64 {
                    let trigger = UNCalendarNotificationTrigger(dateMatching: component.0, repeats: false)
                    let identifier = UUID().uuidString
                    let notificationContent = day!.notificationContent(omerCalendar: calendar, reminderType: component.1)
                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: notificationContent,
                        trigger: trigger
                    )
                    let c = Calendar.current
                    let d = c.date(from: (request.trigger as! UNCalendarNotificationTrigger).dateComponents)!
                    let f = DateFormatter()
                    f.dateFormat = "MM/dd/yyyy HH:mm"
                    let dayId = notificationContent.userInfo["dayId"]!
                    print("\(f.string(from: d)), \(dayId), \(notificationContent.title), \"\(notificationContent.body)\"")
                    center.add(request, withCompletionHandler: { error in
                    })
                }
                count += 1
            }
        }
    }
    func unscheduleNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

}
