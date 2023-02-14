//
//  UserModel.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/16.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import ObjectMapper

class UserModel: Mappable {
    var accountStatus: String?
    var accountType: String?
    var btcMaxPerTrade: Int = 0
    var businessType: String?
    var createdAt: String?
    var email: String?
    var emailVerifiedAt: String?
    var id: Int = 0
    var lang: String?
    var maxRiskExposure: Int = 0
    var name: String?
    var notes: String?
    var phoneCountryCode: String?
    var phoneCountryCodeShort: String?
    var phoneNumber: String?
    var priceAdjustPercentage: Float = 0.0
    var special: String?
    var uniqueId: String?
    var updatedAt: String?
    var userExternalId: String?
    var userSource: String?
    var userType: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accountStatus            <- map["account_status"]
                accountType              <- map["account_type"]
                btcMaxPerTrade           <- map["btc_max_per_trade"]
                businessType             <- map["business_type"]
                createdAt                <- map["created_at"]
                email                    <- map["email"]
                emailVerifiedAt          <- map["email_verified_at"]
                id                       <- map["id"]
                lang                     <- map["lang"]
                maxRiskExposure          <- map["max_risk_exposure"]
                name                     <- map["name"]
                notes                    <- map["notes"]
                phoneCountryCode         <- map["phone_country_code"]
                phoneCountryCodeShort    <- map["phone_country_code_short"]
                phoneNumber              <- map["phone_number"]
                priceAdjustPercentage    <- map["price_adjust_percentage"]
                special                  <- map["special"]
                uniqueId                 <- map["unique_id"]
                updatedAt                <- map["updated_at"]
                userExternalId           <- map["user_external_id"]
                userSource               <- map["user_source"]
                userType                 <- map["user_type"]

    }
}
