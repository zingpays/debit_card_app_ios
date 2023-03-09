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
    
    static func list(uniqueId: String, completion: @escaping ((Bool, String, [CardModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.list(uniqueId: uniqueId), type: CardModel.self, completion: completion)
    }
}

enum CardTarget {
    case status
    case supportType
    case freeze
    case unfreeze
    case list(uniqueId: String)
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
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .list(let uniqueId):
            params["unique_id"] = uniqueId
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
        case .supportType:
            break
        }
        return params
    }
}
