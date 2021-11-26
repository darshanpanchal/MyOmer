//
//  Date+Extensions.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/12/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

extension Date {
    var currentYear: Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.year, from: self)
        }
    }
}
