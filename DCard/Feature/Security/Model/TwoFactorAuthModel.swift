//
//  TwoFactorAuthModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct TwoFactorAuthModel: Mappable {
    
    var secret: String?
    var url: String?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        secret      <- map["secret"]
        url         <- map["google2fa_url"]
    }
}
