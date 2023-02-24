//
//  UserModel.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/16.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import ObjectMapper

class UserModel: Mappable {
    var email: String?
    var name: String?
    var phoneCountryCode: String?
    var phoneCountryCodeShort: String?
    var phoneNumber: String?
    var uniqueId: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        email                    <- map["email"]
        name                     <- map["name"]
        phoneCountryCode         <- map["phone_country_code"]
        phoneCountryCodeShort    <- map["phone_country_code_short"]
        phoneNumber              <- map["phone_number"]
        uniqueId                 <- map["unique_id"]
    }

}
