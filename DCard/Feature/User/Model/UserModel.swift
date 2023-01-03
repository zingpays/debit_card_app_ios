//
//  UserModel.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/16.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import ObjectMapper

/// 账户类型
enum AccountType: String {
    // 个人
    case individual = "Individual"
    // 机构
    case entity = "Entity"
}

class UserModel: Mappable {
    var accountStatus: String?
    var accountType: AccountType?
    var btcMaxPerTrade: Int?
    var businessType: String?
    var createdAt: String?
    var email: String?
    var emailVerifiedAt: String?
    var lang: Language?
    var loginSecurity: LoginSecurity?
    var maxRiskExposure: Int?
    var name: String?
    var notes: String?
    var phoneCountryCode: String?
    var phoneCountryCodeShort: String?
    var phoneNumber: String?
    var priceAdjustPercentage: Float?
    var special: String?
    var uniqueId: String?
    var updatedAt: String?
    var userExternalId: String?
    var userSource: String?
    var userType: String?
    var kycStatus: String?
    var externalUser: ExternalUser?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accountStatus            <- map["account_status"]
        accountType              <- map["account_type"]
        btcMaxPerTrade           <- map["btc_max_per_trade"]
        businessType             <- map["business_type"]
        createdAt                <- map["created_at"]
        email                    <- map["email"]
        emailVerifiedAt          <- map["email_verified_at"]
        lang                     <- map["lang"]
        loginSecurity            <- map["login_security"]
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
        kycStatus                <- map["kyc_status"]
        externalUser             <- map["external_user"]
    }
}

class ExternalUser: Mappable {
    var accountEmail: String?
    var accountType: String?
    var apiToken: String?
    var approvedAt: String?
    var approvedBy: String?
    var createdAt: String?
    var expiresAt: String?
    var hashedId: String?
    var id: Int = 0
    var kycCheckDetails: String?
    var kycCheckId: String?
    var kycCheckResult: String?
    var kycStatus: String?
    var kycWatchlistHit: String?
    var kycWatchlistId: String?
    var kycWatchlistResults: String?
    var kycWatchlistSearchedLists: String?
    var lendingKycStatus: String?
    var notes: String?
    var refCode: String?
    var rejectNotes: String?
    var rejectReason: String?
    var rejectedAt: String?
    var rejectedBy: String?
    var resubmitAt: String?
    var resubmitBy: Int = 0
    var resubmitNotes: String?
    var submittedAt: String?
    var updatedAt: String?
    var userExternalId: String?
    var userSource: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accountEmail                 <- map["account_email"]
        accountType                  <- map["account_type"]
        apiToken                     <- map["api_token"]
        approvedAt                   <- map["approved_at"]
        approvedBy                   <- map["approved_by"]
        createdAt                    <- map["created_at"]
        expiresAt                    <- map["expires_at"]
        hashedId                     <- map["hashed_id"]
        id                           <- map["id"]
        kycCheckDetails              <- map["kyc_check_details"]
        kycCheckId                   <- map["kyc_check_id"]
        kycCheckResult               <- map["kyc_check_result"]
        kycStatus                    <- map["kyc_status"]
        kycWatchlistHit              <- map["kyc_watchlist_hit"]
        kycWatchlistId               <- map["kyc_watchlist_id"]
        kycWatchlistResults          <- map["kyc_watchlist_results"]
        kycWatchlistSearchedLists    <- map["kyc_watchlist_searched_lists"]
        lendingKycStatus             <- map["lending_kyc_status"]
        notes                        <- map["notes"]
        refCode                      <- map["ref_code"]
        rejectNotes                  <- map["reject_notes"]
        rejectReason                 <- map["reject_reason"]
        rejectedAt                   <- map["rejected_at"]
        rejectedBy                   <- map["rejected_by"]
        resubmitAt                   <- map["resubmit_at"]
        resubmitBy                   <- map["resubmit_by"]
        resubmitNotes                <- map["resubmit_notes"]
        submittedAt                  <- map["submitted_at"]
        updatedAt                    <- map["updated_at"]
        userExternalId               <- map["user_external_id"]
        userSource                   <- map["user_source"]
    }
}

class LoginSecurity: Mappable {
    var createdAt: String?
    var google2faEnable: Bool = false
    var id: Int?
    var updatedAt: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        createdAt        <- map["created_at"]
        google2faEnable  <- map["google2fa_enable"]
        id               <- map["id"]
        updatedAt        <- map["updated_at"]
    }
}
