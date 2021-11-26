//
//  OmerCalendar.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/1/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

enum OmerStatus {
    case comingUpCurrentYear
    case omerPeriod
    case comingUpNextYear
}

enum ReminderType {
    case nightReminder
    case dayReminder
    case earlyReminder
    case early1DayReminder
    case early2DayReminder
    case lateReminder
}

class OmerCalendar: NSObject {
    
    let calendar = Calendar.current
    var status = OmerStatus.omerPeriod
    var startDate: Date
    var actualStartDate: Date {
        get {
            let settings = OmerSettings.current
            let startDate = self.startDate
            var startDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
            startDateComponents.hour = settings.nightfallTime.hour
            startDateComponents.minute = settings.nightfallTime.minute
            return calendar.date(from: startDateComponents)!
        }
    }
    var endDate: Date
    var reminders: [OmerReminder] = []
    var daysLeft: Int {
        get {
            var today = Date()
            if (UIApplication.shared.delegate as! AppDelegate).isSetNextDay{
                today = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
            }
            let components = calendar.dateComponents([.day, .hour, .minute], from: today, to: actualStartDate)
            let minutesDifference = components.hour! * 60 + components.minute!
            let todayComponents = calendar.dateComponents([.hour, .minute], from: today)
            let todayMinutes = todayComponents.hour! * 60 + todayComponents.minute!
            let settings = OmerSettings.current
            let nightFallMinutes = settings.nightfallTime.hour * 60 + settings.nightfallTime.minute
            var days = components.day!
            if minutesDifference >= 0 {
                days = days + 1
            }
            else {
                if todayMinutes >= nightFallMinutes {
                    days = days - 1
                }
            }
            return days
        }
    }
    var dayOfOmer: Int {
        get {
            var today = Date()
            if (UIApplication.shared.delegate as! AppDelegate).isSetNextDay{
                today = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
            }
            let components = calendar.dateComponents([.day], from: startDate, to: today)
            let todayComponents = calendar.dateComponents([.hour, .minute], from: today)
            let todayMinutes = todayComponents.hour! * 60 + todayComponents.minute!
            let settings = OmerSettings.current
            let nightFallMinutes = settings.nightfallTime.hour * 60 + settings.nightfallTime.minute
            if todayMinutes >= nightFallMinutes {
                return components.day! + 1
            }
            else {
                return components.day!
            }
        }
    }
    
    init(startDate: Date, endDate: Date, reminders: [OmerReminder]) {
        self.startDate = startDate
        self.endDate = endDate
        self.reminders = reminders
    }
    
    init(calendarData: [String: Any]) {
        self.startDate = OmerCalendar.date(from: calendarData["start"] as! [String: Int])
        self.endDate = OmerCalendar.date(from: calendarData["end"] as! [String: Int])
        let remindersArray = calendarData["reminders"] as! [[String: Bool]]
        for reminderData in remindersArray {
            let reminder = OmerReminder(reminderData: reminderData)
            reminders.append(reminder)
        }
    }
    
    static func getOmerCalendar() -> OmerCalendar {
        
        let path = Bundle.main.path(forResource: "MyOmerCalendar", ofType: "plist")
        let calendarsArray = NSArray(contentsOfFile: path!) as? [[String: Any]]
        
        var calendars: [OmerCalendar] = []
        for calendarData in calendarsArray! {
            let calendar = OmerCalendar(calendarData: calendarData)
            calendars.append(calendar)
        }
        
        var date = Date()
        if (UIApplication.shared.delegate as! AppDelegate).isSetNextDay{
            date = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
        }
        

        let year = date.currentYear
        
        let index = year - 2018
        var calendar = calendars[index]
        
        let c = Calendar.current
        let settings = OmerSettings.current
        
        var startDate = calendar.startDate
        var startDateComponents = c.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        startDateComponents.hour = settings.nightfallTime.hour
        startDateComponents.minute = settings.nightfallTime.minute
        startDate = c.date(from: startDateComponents)!
        
        var endDate = calendar.endDate
        var endDateComponents = c.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        endDateComponents.day = endDateComponents.day! + 1
        endDateComponents.hour = settings.nightfallTime.hour
        endDateComponents.minute = settings.nightfallTime.minute
        endDate = c.date(from: endDateComponents)!
        
        if date <= startDate {
            calendar.status = .comingUpCurrentYear
        }
        else if date > endDate {
            calendar = calendars[index + 1]
            calendar.status = .comingUpNextYear
        }
        else {
            if calendar.daysLeft > 0 {
                calendar.status = .comingUpCurrentYear
            }
            else {
                calendar.status = .omerPeriod
            }
        }
        return calendar
    }
    
    func triggerComponents(for dayId: Int) throws -> [(DateComponents, ReminderType)] {
        
        var componentsArray: [(DateComponents, ReminderType)] = []
        print(dayId)
        if dayId == 0 || dayId > 50 {
            throw OmerError.RuntimeError("Invalid dayId")
        }
        
        let settings = OmerSettings.current
        let reminder = reminders[dayId - 1]
        
        let date = calendar.date(byAdding: .day, value: dayId - 1, to: startDate)!
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        var done = false
        var reminderType: ReminderType
        
        if dayId == 50 {
            if settings.dailyReminder.enabled {
                var finalComponents = DateComponents()
                finalComponents.year = dateComponents.year
                finalComponents.month = dateComponents.month
                finalComponents.day = dateComponents.day! + 1
                finalComponents.calendar = calendar
                finalComponents.hour = settings.dailyReminder.time.hour
                finalComponents.minute = settings.dailyReminder.time.minute
                reminderType = .dayReminder
                componentsArray.append((finalComponents, reminderType))
                return componentsArray
            }
            else {
                return []
            }
        }
        
        if settings.nightlyReminder.enabled {
            
            var finalComponents = DateComponents()
            finalComponents.year = dateComponents.year
            finalComponents.month = dateComponents.month
            finalComponents.day = dateComponents.day
            finalComponents.hour = settings.nightlyReminder.time.hour
            finalComponents.minute = settings.nightlyReminder.time.minute
            reminderType = .dayReminder
            
            if reminder.earlyReminder {
                done = true
                finalComponents.hour = OmerSettings.earlyReminderTime.hour
                finalComponents.minute = OmerSettings.earlyReminderTime.minute
                reminderType = .earlyReminder
            }
            else if reminder.earlyReminder1Day {
                done = true
                finalComponents.day = dateComponents.day! - 1
                finalComponents.hour = OmerSettings.earlyReminderTime.hour
                finalComponents.minute = OmerSettings.earlyReminderTime.minute
                reminderType = .early1DayReminder
            }
            else if reminder.earlyReminder2Days {
                done = true
                finalComponents.day = dateComponents.day! - 2
                finalComponents.hour = OmerSettings.earlyReminderTime.hour
                finalComponents.minute = OmerSettings.earlyReminderTime.minute
                reminderType = .early2DayReminder
            }
            
            if !reminder.lateReminder {
                let finalDate = calendar.date(from: finalComponents)!
                var today = Date()
                if (UIApplication.shared.delegate as! AppDelegate).isSetNextDay{
                    today = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
                }
                if finalDate > today {
                    componentsArray.append((finalComponents, reminderType))
                }
            }
        }
        
        if settings.dailyReminder.enabled && !done {
            
            var finalComponents = DateComponents()
            finalComponents.year = dateComponents.year
            finalComponents.month = dateComponents.month
            finalComponents.day = dateComponents.day! + 1
            finalComponents.calendar = calendar
            finalComponents.hour = settings.dailyReminder.time.hour
            finalComponents.minute = settings.dailyReminder.time.minute
            reminderType = .nightReminder
            
            if reminder.lateReminder {
                finalComponents.day = dateComponents.day!
                finalComponents.hour = OmerSettings.lateReminderTime.hour
                finalComponents.minute = OmerSettings.lateReminderTime.minute
                reminderType = .lateReminder
            }
            
            let finalDate = calendar.date(from: finalComponents)!
            var today = Date()
            if (UIApplication.shared.delegate as! AppDelegate).isSetNextDay{
                today = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
            }
            if finalDate > today {
                componentsArray.append((finalComponents, reminderType))
            }
        }
        
        return componentsArray
    }
    
    func week(for omerDay: Int) -> String {
        let date = calendar.date(byAdding: .day, value: omerDay - 1, to: startDate)!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    fileprivate static func date(from components: [String: Int]) -> Date {
        
        let year = components["year"]
        let month = components["month"]
        let day = components["day"]
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let c = Calendar.current
        return c.date(from: dateComponents)!
    }
}
