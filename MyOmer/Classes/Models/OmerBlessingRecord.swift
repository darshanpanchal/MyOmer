//
//  OmerBlessingRecord.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/11/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class OmerBlessingRecord: Object {

    @objc dynamic var dayId: Int = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    @objc dynamic var year: Int = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    @objc dynamic var blessingSaid: Bool = false {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    @objc dynamic var compoundKey: String = ""
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(day: OmerDay, year: Int) {
        super.init()
        self.dayId = day.day
        self.year = year
        self.blessingSaid = true
        self.compoundKey = compoundKeyValue()
    }
    
    static func pendingBlessings(until dayId: Int) -> Int {
        var pb = 0
        for i in 1...dayId {
            let day = OmerDay(day: i)
            let blessingSaid = day.isBlessingSaid(forYear: Date().currentYear)
            if !blessingSaid {
                pb += 1
            }
        }
        return pb
    }
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(dayId)\(year)"
    }
}
