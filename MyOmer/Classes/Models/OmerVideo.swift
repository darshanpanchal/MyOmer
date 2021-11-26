//
//  OmerVideo.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/8/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerVideo: NSObject {

    var title: String
    var desc: String
    var youtubeVideoUrl: URL
    
    init(title: String, desc: String, youtubeVideoUrl: URL) {
        self.title = title
        self.desc = desc
        self.youtubeVideoUrl = youtubeVideoUrl
    }
    
    init(videoData: [String: String]) {
        self.title = videoData["title"]!
        self.desc = videoData["description"]!
        self.youtubeVideoUrl = URL(string: videoData["youtube_url"]!)!
    }
}
