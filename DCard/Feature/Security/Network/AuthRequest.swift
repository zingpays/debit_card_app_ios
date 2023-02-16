//
//  AuthRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/16.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct AuthRequest {
    static func verifyCode(uniqueId: String, authToken: String, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestStatus(.verifyCode(uniqueId: uniqueId, authToken: authToken),
                               completion: completion)
    }
}

enum AuthTarget {
    case verifyCode(uniqueId: String, authToken: String)
}

extension AuthTarget: BaseTargetType {
    var path: String {
        switch self {
        case .verifyCode:
            return "/security/verify2fa"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .verifyCode(let uniqueId, let authToken):
            params["unique_id"] = uniqueId
            params["auth_token"] = authToken
        }
        return params
    }
}
