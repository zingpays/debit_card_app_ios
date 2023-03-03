//
//  SuppportCardInfoModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct SuppportCardInfoModel: Mappable {
    
    var type: String?
    var currency: String?
    var rebate: String?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        type             <- map["type"]
        currency         <- map["currency"]
        rebate           <- map["rebate"]
    }
}
