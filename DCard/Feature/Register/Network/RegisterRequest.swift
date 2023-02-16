//
//  RegisterRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/16.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct RegisterRequest {
    static func register(email: String, password: String, code: String, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<RegisterTarget>()
        provider.requestStatus(.register(email: email, password: password, code: code),
                               completion: completion)
    }
}

enum RegisterTarget {
    case register(email: String, password: String, code: String)
}

extension RegisterTarget: BaseTargetType {
    var path: String {
        switch self {
        case .register:
            return ""
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .register(let email, let password, let code):
            params["email"] = email
            params["password"] = password
            params["code"] = code
        }
        return params
    }
}
