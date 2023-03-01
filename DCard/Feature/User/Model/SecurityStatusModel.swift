//
//  SecurityStatusModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct SecurityStatusItemModel: Mappable {
    var value: String?
    var status: Bool = false
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        value           <- map["value"]
        status          <- map["status"]
    }
}

struct SecurityStatusModel: Mappable {
    
    var email: SecurityStatusItemModel?
    var phone: SecurityStatusItemModel?
    var twoFa: SecurityStatusItemModel?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        email          <- map["email"]
        phone          <- map["phone"]
        twoFa          <- map["twofa"]
    }
}
