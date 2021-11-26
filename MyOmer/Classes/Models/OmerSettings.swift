//
//  OmerSettings.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/16/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

fileprivate struct Keys {
    internal struct Nightfall {
        static let hour = "nightfall.hour"
        static let minute = "nightfall.minute"
    }
    internal struct Nightly {
        static let enabled = "nightlyReminder.enabled"
        static let hour = "nightlyReminder.hour"
        static let minute = "nightlyReminder.minute"
    }
    internal struct Daily {
        static let enabled = "dailyReminder.enabled"
        static let hour = "dailyReminder.hour"
        static let minute = "dailyReminder.minute"
    }
    internal struct Notification {
        static let enabled = "notification"
    }
}
struct Notify {
     var enabled = true
}
struct Time {
    
    var hour = 0
    var minute = 0
    var date: Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "H:m"
            return formatter.date(from: "\(hour):\(minute)")!
        }
    }
    func description() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

struct Reminder {
    var time: Time
    var enabled = true
}

class OmerSettings: NSObject {
    
    var nightfallTime = Time(hour: 0, minute: 0)
    var nightlyReminder: Reminder = Reminder(time: Time(hour: 0, minute: 0), enabled: false)
    var dailyReminder: Reminder = Reminder(time: Time(hour: 0, minute: 0), enabled: false)
    var notificationEnable = Notify(enabled: true)
    fileprivate static var defaultNightfallTime = Time(hour: 20, minute: 0)
    fileprivate static var defaultNightlyReminderTime = Time(hour: 20, minute: 0)
    fileprivate static var defaultDailyReminderTime = Time(hour: 12, minute: 0)
    fileprivate static var defaultNotification =  Notify(enabled: false)
    static var earlyReminderTime = Time(hour: 14, minute: 30)
    static var lateReminderTime = Time(hour: 22, minute: 30)
    
    class var current: OmerSettings {
        get {
            let defaults = UserDefaults.standard
            if defaults.object(forKey: Keys.Nightly.enabled) == nil {
                defaults.set(defaultNightfallTime.hour, forKey: Keys.Nightfall.hour)
                defaults.set(defaultNightfallTime.minute, forKey: Keys.Nightfall.minute)
                defaults.set(true, forKey: Keys.Nightly.enabled)
                defaults.set(false, forKey: Keys.Daily.enabled)
                defaults.set(defaultNightlyReminderTime.hour, forKey: Keys.Nightly.hour)
                defaults.set(defaultNightlyReminderTime.minute, forKey: Keys.Nightly.minute)
                defaults.set(defaultDailyReminderTime.hour, forKey: Keys.Daily.hour)
                defaults.set(defaultDailyReminderTime.minute, forKey: Keys.Daily.minute)
                defaults.set(false, forKey: Keys.Notification.enabled)
                defaults.synchronize()
            }
            let setting = OmerSettings()
            setting.nightfallTime = Time(
                hour: defaults.integer(forKey: Keys.Nightfall.hour),
                minute: defaults.integer(forKey: Keys.Nightfall.minute)
            )
            setting.nightlyReminder = Reminder(
                time: Time(
                    hour: defaults.integer(forKey: Keys.Nightly.hour),
                    minute: defaults.integer(forKey: Keys.Nightly.minute)
                ),
                enabled: defaults.bool(forKey: Keys.Nightly.enabled)
            )
            setting.dailyReminder = Reminder(
                time: Time(
                    hour: defaults.integer(forKey: Keys.Daily.hour),
                    minute: defaults.integer(forKey: Keys.Daily.minute)
                    ),
                enabled: defaults.bool(forKey: Keys.Daily.enabled)
            )
            setting.notificationEnable = Notify(
                enabled: defaults.bool(forKey: Keys.Notification.enabled)
            )
            return setting
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(nightfallTime.hour, forKey: Keys.Nightfall.hour)
        defaults.set(nightfallTime.minute, forKey: Keys.Nightfall.minute)
        defaults.set(nightlyReminder.enabled, forKey: Keys.Nightly.enabled)
        defaults.set(dailyReminder.enabled, forKey: Keys.Daily.enabled)
        defaults.set(nightlyReminder.time.hour, forKey: Keys.Nightly.hour)
        defaults.set(nightlyReminder.time.minute, forKey: Keys.Nightly.minute)
        defaults.set(dailyReminder.time.hour, forKey: Keys.Daily.hour)
        defaults.set(dailyReminder.time.minute, forKey: Keys.Daily.minute)
        defaults.set(notificationEnable.enabled, forKey: Keys.Notification.enabled)
        defaults.synchronize()
    }
}
