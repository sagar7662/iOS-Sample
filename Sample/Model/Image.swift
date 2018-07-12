//
//  Image.swift
//  Sample
//
//  Created by SK on 7/12/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import ObjectMapper

struct Image: Mappable {
    
    var text = ""
    var size = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        text <- map["#text"]
        size <- map["size"]
    }
}
