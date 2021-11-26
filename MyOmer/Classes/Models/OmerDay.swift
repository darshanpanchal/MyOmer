//
//  OmerDay.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/6/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class OmerDay: NSObject {
    
    var day: Int
    var week: Int
    var dayOfWeek: Int
    var quote: MultilingualText
    var sefirah: MultilingualText
    var title: String
    var shortTitle: String {
        get {
            let components = title.components(separatedBy: " ")
            if components.count > 1 {
                return components[0]
            }
            return ""
        }
    }
    var subtitle: String
    var content: String
    var video: OmerVideo?
    var exercise: String
    var questions: [OmerQuestion] = []
    
    init(day: Int, week: Int, dayOfWeek: Int, quote: MultilingualText, sefirah: MultilingualText, title: String, subtitle: String, content: String, exercise: String, questions: [OmerQuestion]) {
        self.day = day
        self.week = week
        self.dayOfWeek = dayOfWeek
        self.quote = quote
        self.sefirah = sefirah
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.exercise = exercise
        self.questions = questions
    }
    
    init(day: Int) {
        let path = Bundle.main.path(forResource: "day\(day)", ofType: "plist")!
        let dailyData = NSDictionary(contentsOfFile: path) as! [String: Any]
        self.day = dailyData["day"] as! Int
        self.week = dailyData["week"] as! Int
        self.dayOfWeek = dailyData["dayOfWeek"] as! Int
        var quote = dailyData["quote"] as! [String: String]
        self.quote = MultilingualText(
            en: quote["en"]!,
            es: quote["es"]!,
            fr: quote["fr"]!,
            ru: quote["ru"]!,
            hb: quote["hb"]!
        )
        var sefirah = dailyData["sefirah"] as! [String: String]
        self.sefirah = MultilingualText(
            en: sefirah["en"]!,
            es: sefirah["es"]!,
            fr: sefirah["fr"]!,
            ru: sefirah["ru"]!,
            hb: sefirah["hb"]!
        )
        self.title = dailyData["title"] as! String
        self.subtitle = dailyData["subtitle"] as! String
        self.content = dailyData["content"] as! String
        if dailyData.keys.contains("video") {
            self.video = OmerVideo(videoData: dailyData["video"] as! [String : String])
        }
        self.exercise = dailyData["exercise"] as! String
        self.questions = OmerQuestion.import(questionsArray: dailyData["questions"] as! [[String:Any]])
    }
    
    func isBlessingSaid(forYear year: Int) -> Bool {
        let realm = try! Realm()
        if let blessingRecord = realm.object(ofType: OmerBlessingRecord.self, forPrimaryKey: "\(day)\(year)") {
            return blessingRecord.blessingSaid
        }
        return false
    }
    
    func markBlessing(_ blessingSaid: Bool, forYear year: Int) {
        let realm = try! Realm()
        let blessingRecord = OmerBlessingRecord(day: self, year: year)
        blessingRecord.blessingSaid = blessingSaid
        try! realm.write {
            realm.add(blessingRecord, update: true)
        }
        
        let calendar = OmerCalendar.getOmerCalendar()
        let dayId = calendar.dayOfOmer
        let pendingBlessings = OmerBlessingRecord.pendingBlessings(until: dayId)
        
        UIApplication.shared.applicationIconBadgeNumber = 1
    }
    
    func notificationContent(omerCalendar: OmerCalendar, reminderType: ReminderType) -> UNNotificationContent {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let ordinal = numberFormatter.string(from: NSNumber(value: day))!.lowercased()
        
        let content = UNMutableNotificationContent()
        if reminderType == .dayReminder {
            
        }
        content.badge = 1
        if day == 1 {
            content.title = Config.Notification.firstDayTitle
        }
        else if day == 49 || day == 50 {
            content.title = Config.Notification.lastDayTitle
        }
        else {
            content.title = Config.Notification.otherDaysTitle
        }
        
        var body = ""
        
        if day == 1 {
            body = Config.Notification.firstNightBody
        }
        else if day == 49 || day == 50 {
            if reminderType == .dayReminder {
                body = "Today \(Config.Notification.lastDayBody)"
            }
            else {
                body = "Tonight \(Config.Notification.lastDayBody)"
            }
        }
        else {
            if reminderType == .nightReminder || reminderType == .earlyReminder {
                if reminderType == .nightReminder {
                    body = "Today is the \(ordinal) day of the Omer. \(Config.Notification.countString)"
                }
                else {
                    if day % 7 == 0 {
                        body = "Tonight is the \(ordinal) day of the Omer. \(Config.Notification.countStringAfter)"
                    }
                    else {
                        body = "Tonight is the \(ordinal) day of the Omer. \(Config.Notification.countString)"
                    }
                }
            }
            else if reminderType == .dayReminder || reminderType == .lateReminder {
                body = "Tonight is the \(ordinal) day of the Omer. \(exercise)"
            }
            else if reminderType == .early1DayReminder || reminderType == .early2DayReminder {
                let weekName = omerCalendar.week(for: day)
                body = "\(weekName) night is the \(ordinal) day of the Omer. \(exercise)"
            }
        }
        content.body = body
        
        content.sound = UNNotificationSound.default
        content.userInfo = [
            "weekId": week,
            "dayId": day
            ]
        return content
    }
}
