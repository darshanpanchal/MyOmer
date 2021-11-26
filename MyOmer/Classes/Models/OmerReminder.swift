//
//  OmerReminder.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/14/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerReminder: NSObject {
    
    var earlyReminder = false
    var lateReminder = false
    var earlyReminder1Day = false
    var earlyReminder2Days = false
    
    init(reminderData: [String: Bool]) {
        self.earlyReminder = reminderData["early"]!
        self.lateReminder = reminderData["late"]!
        self.earlyReminder1Day = reminderData["dayEarly"]!
        self.earlyReminder2Days = reminderData["2daysEarly"]!
    }
}
