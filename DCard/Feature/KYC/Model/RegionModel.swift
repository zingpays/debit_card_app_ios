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
    /// 手机国家码
    var phoneCode: String?
    /// 手机号码长度限制，空就不校验
    var phoneNumberLen: RegionPhoneNumLengthModel?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        id             <- map["id"]
        nameEn         <- map["name_en"]
        nameZh         <- map["name_zh"]
        phoneCode      <- map["phone_code"]
        phoneNumberLen <- map["phone_number_len"]
    }
}

struct RegionPhoneNumLengthModel: Mappable {
    
    var min: Int?
    var max: String?
    
    init?(map: ObjectMapper.Map) {}

    mutating func mapping(map: Map) {
        min             <- map["min"]
        max             <- map["max"]
    }
}

struct RegionItemModel: Mappable {
    
    var cityCode: String?
    var createdAt: String?
    var id: Int = 0
    var iso2Code: String?
    var iso3Code: String?
    var letter: String?
    var nameEn: String?
    var nameZh: String?
    var parentId: Int = 0
    var phoneCode: String?
    var status: String?
    var type: Int = 0
    var updatedAt: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        cityCode   <- map["city_code"]
        createdAt  <- map["created_at"]
        id         <- map["id"]
        iso2Code   <- map["iso2_code"]
        iso3Code   <- map["iso3_code"]
        letter     <- map["letter"]
        nameEn     <- map["name_en"]
        nameZh     <- map["name_zh"]
        parentId   <- map["parent_id"]
        phoneCode  <- map["phone_code"]
        status     <- map["status"]
        type       <- map["type"]
        updatedAt  <- map["updated_at"]
    }

}
