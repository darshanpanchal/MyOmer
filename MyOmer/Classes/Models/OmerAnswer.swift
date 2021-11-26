//
//  OmerAnswer.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/10/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class OmerAnswer: Object {
    
    @objc dynamic var questionId: Int = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    @objc dynamic var year: Int = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    @objc dynamic var answer: String = ""
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
    
    required init(question: OmerQuestion, year: Int, answer: String) {
        super.init()
        self.questionId = question.id
        self.year = year
        self.answer = answer
        self.compoundKey = compoundKeyValue()
    }
    
    override static func primaryKey() -> String {
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(questionId)\(year)"
    }
}
