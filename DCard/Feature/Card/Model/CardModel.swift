//
//  CardModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct CardModel: Mappable {
    
    var availableBalance: String?
    var balance: String?
    var cardCvc: String?
    var cardName: String?
    var cardNumber: String?
    var cardType: String?
    var createdAt: String?
    var currency: String?
    var dailyLimit: String?
    var expenseLimit: String?
    var expireDate: String?
    var externalCardId: String?
    var monthlyLimit: String?
    var note: String?
    var partnerId: Int = 0
    var rebateAmount: String?
    var rebateRate: String?
    var status: CardStatus = .normal
    var transitAmount: String?
    var uniqueId: Int = 0
    var updatedAt: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        availableBalance  <- map["available_balance"]
        balance           <- map["balance"]
        cardCvc           <- map["card_cvc"]
        cardName          <- map["card_name"]
        cardNumber        <- map["card_number"]
        cardType          <- map["card_type"]
        createdAt         <- map["created_at"]
        currency          <- map["currency"]
        dailyLimit        <- map["daily_limit"]
        expenseLimit      <- map["expense_limit"]
        expireDate        <- map["expire_date"]
        externalCardId    <- map["external_card_id"]
        monthlyLimit      <- map["monthly_limit"]
        note              <- map["note"]
        partnerId         <- map["partner_id"]
        rebateAmount      <- map["rebate_amount"]
        rebateRate        <- map["rebate_rate"]
        status            <- map["status"]
        transitAmount     <- map["transit_amount"]
        uniqueId          <- map["unique_id"]
        updatedAt         <- map["updated_at"]
    }
}

enum CardStatus: String {
    case normal = "Normal"
    case frozen = "Frozen"
    case closed = "Closed"
}

struct CardStatusModel: Mappable {
    
    var status: CardStatus = .normal

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        status           <- map["status"]
    }
}
