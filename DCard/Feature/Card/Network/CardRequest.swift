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
    static func supportType(completion: @escaping ((Bool, String, [SuppportCardInfoModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.supportType, type: SuppportCardInfoModel.self, completion: completion)
    }
    
    static func list(uniqueId: String, completion: @escaping ((Bool, String, [CardModel]?) -> Void)) {
        let provider = MoyaProvider<CardTarget>()
        provider.requestObjects(.list(uniqueId: uniqueId), type: CardModel.self, completion: completion)
    }
}

enum CardTarget {
    case supportType
    case list(uniqueId: String)
}

extension CardTarget: BaseTargetType {
    var path: String {
        switch self {
        case .supportType:
            return "/virtual-card/list-supported-card-types"
        case .list:
            return "/virtual-card/list"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .list(let uniqueId):
            params["unique_id"] = uniqueId
        case .supportType:
            break
        }
        return params
    }
}
