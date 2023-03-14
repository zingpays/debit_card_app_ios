//
//  LoginUserInfo.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct LoginInfoModel: Mappable {
    
    var userId: String?
    var nickName: String?
    var realName: String?
    var cardName: String?
    var avatar: String?
    var desc: String?
    var homePath: String?
    var email: String?
    var roles: [String]?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        userId            <- map["id"]
        nickName          <- map["nick_name"]
        realName          <- map["real_name"]
        cardName          <- map["card_name"]
        avatar            <- map["avatar"]
        desc              <- map["desc"]
        homePath          <- map["homePath"]
        email             <- map["email"]
        roles             <- map["roles"]
    }
}
