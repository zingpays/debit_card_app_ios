//
//  TokenRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct TokenRequest {
//    static func access(refreshToken: String, )
}

enum TokenTarget {
    case access(refreshToken: String)
}

extension TokenTarget: BaseTargetType {
    var path: String {
        switch self {
        case .access(let refreshToken):
            return "/auth-front/get-access-token"
        }
    }

    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .access(let refreshToken):
            params["refresh_token"] = refreshToken
        }
        return params
    }
}
