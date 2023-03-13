//
//  CardRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct CardRequest {
    
    static func status(completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.status, type: CardStatusModel.self, completion: completion)
    }
    
    static func supportType(completion: @escaping ((Bool, String, [SuppportCardInfoModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.supportType, type: SuppportCardInfoModel.self, completion: completion)
    }
    
    static func freeze(completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.freeze, type: CardStatusModel.self, completion: completion)
    }
    
    static func unfreeze(completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.unfreeze, type: CardStatusModel.self, completion: completion)
    }
    
    static func list(completion: @escaping ((Bool, String, [CardModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.list, type: CardModel.self, completion: completion)
    }
    
    static func open(completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestStatus(.open, completion: completion)
    }
    
    static func info(completion: @escaping ((Bool, String, CardModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.info, type: CardModel.self, completion: completion)
    }
    
    static func transations(page: Int, per: Int,
                            completion: @escaping ((Bool, String, TransactionsModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.transations(page: page, per: per), type: TransactionsModel.self, completion: completion)
    }
}

enum CardTarget {
    case status
    case supportType
    case freeze
    case unfreeze
    case list
    case open
    case info
    case transations(page: Int, per: Int)
}

extension CardTarget: BaseTargetType {
    var path: String {
        switch self {
        case .supportType:
            return "/virtual-card/list-supported-card-types"
        case .list:
            return "/virtual-card/list"
        case .status:
            return "/virtual-card/status"
        case .freeze:
            return "/virtual-card/freeze"
        case .unfreeze:
            return "/virtual-card/unfreeze"
        case .open:
            return "/virtual-card/open"
        case .info:
            return "/virtual-card/info"
        case .transations:
            return "/virtual-card/list-transactions"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .list:
            params["unique_id"] = "6648244"
        case .status:
            params["unique_id"] = "6648244"
            params["partner_name"] = "metaprise"
            params["_skip_auth"] = 1
        case .freeze:
            params["unique_id"] = "6648244"
            params["partner_name"] = "metaprise"
        case .unfreeze:
            params["unique_id"] = "6648244"
            params["partner_name"] = "metaprise"
        case .open:
            params["unique_id"] = "6648244"
            params["_skip_auth"] = 1
            params["type"] = "visa_virtual_debit_card"
            params["base_currency"] = "USD"
        case .info:
            params["unique_id"] = "6648244"
            params["_skip_auth"] = 1
            params["partner_name"] = "metaprise"
        case .transations(let page, let per):
            params["unique_id"] = "6648244"
            params["_skip_auth"] = 1
            params["partner_name"] = "metaprise"
            params["page"] = page
            params["per_page"] = per
        case .supportType:
            break
        }
        return params
    }
}
