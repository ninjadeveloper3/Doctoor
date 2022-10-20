//
//  BannarImages.swift
//  Doctoor
//
//  Created by DevBatch on 15/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class BannarImages: Mappable {

    var id = 0
    var mediaType = ""
    var file = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        mediaType   <-  map["media_type"]
        file        <-  map["file"]
    }
}

class VersionModel: Mappable {
    
    var ios = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ios          <-  map["iosApplicationVersion"]
    }
}
