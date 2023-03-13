//
//  TransactionsModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation
import ObjectMapper

struct TransactionsModel: Mappable {
    var currentPage: Int = 0
    var list: [TransactionItemModel]?
    var firstPageUrl: String?
    var from: Int = 0
    var lastPage: Int = 0
    var lastPageUrl: String?
    var nextPageUrl: String?
    var path: String?
    var perPage: Int = 0
    var prevPageUrl: String?
    var to: Int = 0
    var total: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        currentPage    <- map["current_page"]
        list           <- map["data"]
        firstPageUrl   <- map["first_page_url"]
        from           <- map["from"]
        lastPage       <- map["last_page"]
        lastPageUrl    <- map["last_page_url"]
        nextPageUrl    <- map["next_page_url"]
        path           <- map["path"]
        perPage        <- map["per_page"]
        prevPageUrl    <- map["prev_page_url"]
        to             <- map["to"]
        total          <- map["total"]
    }
}

struct TransactionItemModel: Mappable {
    var accountType: String?
    var amount: String?
    var asset: String?
    var balance: String?
    var createdAt: String?
    var direction: String?
    var merchant: TransactionMerchantModel?
    var note: String?
    var reference: String?
    var status: String?
    var type: TransactionType = .deposit
    var uniqueId: Int = 0
    var updatedAt: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        accountType  <- map["account_type"]
        amount       <- map["amount"]
        asset        <- map["asset"]
        balance      <- map["balance"]
        createdAt    <- map["created_at"]
        direction    <- map["direction"]
        merchant     <- map["merchant"]
        note         <- map["note"]
        reference    <- map["reference"]
        status       <- map["status"]
        type         <- map["type"]
        uniqueId     <- map["unique_id"]
        updatedAt    <- map["updated_at"]
    }
}

struct TransactionMerchantModel: Mappable {
    var category: String?
    var categoryCode: String?
    var city: String?
    var country: String?
    var name: String?
    var networkId: String?
    var postalCode: String?
    var state: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        category      <- map["category"]
        categoryCode  <- map["category_code"]
        city          <- map["city"]
        country       <- map["country"]
        name          <- map["name"]
        networkId     <- map["network_id"]
        postalCode    <- map["postal_code"]
        state         <- map["state"]
    }
}

enum TransactionType: String {
    case consume = "Consume" // 消费
    case consumeRefund = "Consume Refund" // 退款
    case deposit = "Card Deposit" // 充值
    case rebate = "Rebate" // 返现
    case all = "All" // 全部
    case card = "Card" //虚拟卡
    
    func formatName() -> String {
        switch self {
        case .consume:
            return R.string.localizable.consume()
        case .consumeRefund:
            return R.string.localizable.consumeRefund()
        case .deposit:
            return R.string.localizable.deposit()
        case .rebate:
            return R.string.localizable.rebate()
        case .all:
            return R.string.localizable.all()
        case .card:
            return R.string.localizable.virtualCard()
        }
    }
}

