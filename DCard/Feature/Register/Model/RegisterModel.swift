//
//  RegisterModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/24.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct RegisterModel: Mappable {
    
    var id: Int?
    var email: String?
    var uniqueId: Int?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        id            <- map["id"]
        email         <- map["email"]
        uniqueId      <- map["unique_id"]
    }
}
