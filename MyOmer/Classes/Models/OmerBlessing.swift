//
//  OmerBlessing.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/6/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerBlessing: NSObject {

    var blessing: MultilingualText
    
    override init() {
        let path = Bundle.main.path(forResource: "Blessings", ofType: "plist")!
        let blessingsData = NSDictionary(contentsOfFile: path) as! [String: String]
        blessing = MultilingualText(
            en: blessingsData["en"]!,
            es: blessingsData["es"]!,
            fr: blessingsData["fr"]!,
            ru: blessingsData["ru"]!,
            hb: blessingsData["hb"]!
        )
    }
}
