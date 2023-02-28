//
//  VerifyMailModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct VerifyMailModel: Mappable {
    
    var verifyCode: String?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        verifyCode      <- map["verify_code"]
    }
}
