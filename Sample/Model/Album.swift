//
//  Album.swift
//  Sample
//
//  Created by SK on 7/12/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import ObjectMapper

class Album: Mappable {
    
    var mbid = ""
    var name = ""
    var playcount = 0
    var url = ""
    var images = [Image]()
    var artist: Artist?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mbid <- map["mbid"]
        name <- map["name"]
        playcount <- map["playcount"]
        url <- map["url"]
        images <- map["image"]
        artist <- map["artist"]
    }
}
