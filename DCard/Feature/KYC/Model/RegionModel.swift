//
//  RegionModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/25.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct RegionModel: Mappable {
    
    var id: Int?
    var nameEn: String?
    var nameZh: String?
    var phoneCode: String?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        id             <- map["id"]
        nameEn         <- map["name_en"]
        nameZh         <- map["name_zh"]
        phoneCode      <- map["phone_code"]
    }
}
