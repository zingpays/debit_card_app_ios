//
//  RegionRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/25.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct RegionRequest {
    static func list(completion: @escaping ((Bool, String, [RegionModel]?) -> Void)) {
        let provider = MoyaProvider<RegionTarget>()
        provider.requestObjects(.list, type: RegionModel.self, completion: completion)
    }
}

enum RegionTarget {
    case list
}

extension RegionTarget: BaseTargetType {
    var path: String {
        switch self {
        case .list:
            return "/region/list"
        }
    }
    
    var needAuthorization: Bool {
        return false
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .list:
            break
        }
        return params
    }
}
