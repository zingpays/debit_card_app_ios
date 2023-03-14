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
    
    static func status(partnerName: String, completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.status(partnerName: partnerName), type: CardStatusModel.self, completion: completion)
    }
    
    static func supportType(completion: @escaping ((Bool, String, [SuppportCardInfoModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.supportType, type: SuppportCardInfoModel.self, completion: completion)
    }
    
    static func freeze(partnerName: String, completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.freeze(partnerName: partnerName), type: CardStatusModel.self, completion: completion)
    }
    
    static func unfreeze(partnerName: String, completion: @escaping ((Bool, String, CardStatusModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.unfreeze(partnerName: partnerName), type: CardStatusModel.self, completion: completion)
    }
    
    static func list(completion: @escaping ((Bool, String, [CardModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.list, type: CardModel.self, completion: completion)
    }
    
    static func open(completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestStatus(.open, completion: completion)
    }
    
    static func info(partnerName: String, completion: @escaping ((Bool, String, CardModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.info(partnerName: partnerName), type: CardModel.self, completion: completion)
    }
    
    static func transations(type: String? = nil,
                            dateTo: String? = nil,
                            dateForm: String? = nil,
                            page: Int,
                            per: Int,
                            partnerName: String,
                            completion: @escaping ((Bool, String, TransactionsModel?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObject(.transations(type: type, dateForm: dateForm, dateTo: dateTo, page: page, per: per, partnerName: partnerName), type: TransactionsModel.self, completion: completion)
    }
}

enum CardTarget {
    case list
    case open
    case supportType
    case status(partnerName: String)
    case freeze(partnerName: String)
    case unfreeze(partnerName: String)
    case info(partnerName: String)
    case transations(type: String?, dateForm: String?, dateTo: String?, page: Int, per: Int, partnerName: String)
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
            break
            //params["unique_id"] = "6648244"
        case .status(let partnerName):
//            params["unique_id"] = "6648244"
//            params["partner_name"] = "metaprise"
            params["partner_name"] = partnerName
//            params["_skip_auth"] = 1
        case .freeze(let partnerName):
//            params["unique_id"] = "6648244"
//            params["partner_name"] = "metaprise"
            params["partner_name"] = partnerName
        case .unfreeze(let partnerName):
//            params["unique_id"] = "6648244"
            params["partner_name"] = partnerName
        case .open:
//            params["unique_id"] = "6648244"
//            params["_skip_auth"] = 1
            params["type"] = "visa_virtual_debit_card"
            params["base_currency"] = "USD"
        case .info(let partnerName):
//            params["unique_id"] = "6648244"
//            params["_skip_auth"] = 1
            params["partner_name"] = partnerName
        case .transations(let type, let dateForm, let dateTo, let page, let per, let partnerName):
//            params["unique_id"] = "6648244"
//            params["_skip_auth"] = 1
            params["partner_name"] = partnerName
            params["page"] = page
            params["per_page"] = per
            params["type"] = type
            params["date_to"] = dateTo
            params["date_from"] = dateForm
        case .supportType:
            break
        }
        return params
    }
}
