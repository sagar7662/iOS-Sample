//
//  Artist.swift
//  Sample
//
//  Created by SK on 7/12/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import ObjectMapper

class Artist: Mappable {
    
    var listeners = 0
    var mbid = ""
    var name = ""
    var playcount = 0
    var streamable = 0
    var url = ""
    var images = [Image]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        listeners <- map["listeners"]
        mbid <- map["mbid"]
        name <- map["name"]
        playcount <- map["playcount"]
        streamable <- map["streamable"]
        url <- map["url"]
        images <- map["image"]
    }
}
