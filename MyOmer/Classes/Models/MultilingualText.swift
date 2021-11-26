//
//  MultilingualText.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/7/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

enum OmerLanguage: UInt {
    
    case en = 1
    case es = 2
    case fr = 3
    case ru = 4
    case hb = 5
    
    var description: String {
        switch self {
        case .en:
            return "EN"
        case .es:
            return "ES"
        case .fr:
            return "FR"
        case .ru:
            return "RU"
        case .hb:
            return "HB"
        }
    }
}

struct MultilingualText {
    
    var en: String
    var es: String
    var fr: String
    var ru: String
    var hb: String
    
    init(en: String, es: String, fr: String, ru: String, hb: String) {
        self.en = en
        self.es = es
        self.fr = fr
        self.ru = ru
        self.hb = hb
    }
    
    func get(language: OmerLanguage) -> String {
        if language == .en {
            return en
        }
        else if language == .es {
            return es
        }
        else if language == .fr {
            return fr
        }
        else if language == .ru {
            return ru
        }
        else {
            return hb
        }
    }
    
}
