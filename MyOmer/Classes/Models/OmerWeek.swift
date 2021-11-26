//
//  OmerWeek.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerWeek: NSObject {
    
    var id: Int = 0
    var title: String
    var subtitle: String
    var content: String
    var youtubeVideoUrl: String
    var primaryColor: UIColor
    var secondaryColor: UIColor
    
    init(title: String, subtitle: String, content: String, youtubeVideoUrl: String, primaryColor: UIColor, secondaryColor: UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.youtubeVideoUrl = youtubeVideoUrl
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    init(week: Int) {
        let path = Bundle.main.path(forResource: "week\(week)", ofType: "plist")!
        let weeklyData = NSDictionary(contentsOfFile: path) as! [String: String]
        self.id = week
        self.title = weeklyData["title"]!
        self.subtitle = weeklyData["subtitle"]!
        self.content = weeklyData["content"]!
        self.youtubeVideoUrl = weeklyData["youtube_url"]!
        
        self.primaryColor = UIColor(hexString: weeklyData["color"]!)
        self.secondaryColor = UIColor(hexString: weeklyData["secondaryColor"]!)
    }
    
    func days() -> [OmerDay] {
        return [
            OmerDay(day: (id-1)*7+1),
            OmerDay(day: (id-1)*7+2),
            OmerDay(day: (id-1)*7+3),
            OmerDay(day: (id-1)*7+4),
            OmerDay(day: (id-1)*7+5),
            OmerDay(day: (id-1)*7+6),
            OmerDay(day: (id-1)*7+7),
        ]
    }
}
