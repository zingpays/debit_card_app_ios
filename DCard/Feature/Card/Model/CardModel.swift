//
//  CardModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct CardModel: Mappable {
    
    var uniqueId: Int = 0
    var balance: String?
    var cardCvc: String?
    var cardName: String?
    var cardNumber: String?
    var cardType: String?
    var createdAt: String?
    var currency: String?
    var displayName: String?
    var expenseLimit: String?
    var expireDate: String?
    var externalCardId: String?
    var partnerName: String?
    var status: String?
    var updatedAt: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        balance          <- map["balance"]
        cardCvc          <- map["card_cvc"]
        cardName         <- map["card_name"]
        cardNumber       <- map["card_number"]
        cardType         <- map["card_type"]
        createdAt        <- map["created_at"]
        currency         <- map["currency"]
        displayName      <- map["display_name"]
        expenseLimit     <- map["expense_limit"]
        expireDate       <- map["expire_date"]
        externalCardId   <- map["external_card_id"]
        partnerName      <- map["partner_name"]
        status           <- map["status"]
        uniqueId         <- map["unique_id"]
        updatedAt        <- map["updated_at"]
    }
}
