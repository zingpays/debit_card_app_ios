//
//  MailRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/16.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

enum MailCodeType: String {
    case login = "Login"
    case register = "Register"
}

struct MailRequest {
    static func sendCode(email: String,
                         type: MailCodeType,
                         completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.sendCode(email: email, type: type),
                               completion: completion)
    }
    
    static func verifyCode(email: String,
                           code: String,
                           authToken: String? = nil,
                           completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.verifyCode(email: email, code: code, authToken: authToken),
                               completion: completion)
    }
}

enum MailTarget {
    case sendCode(email: String, type: MailCodeType)
    case verifyCode(email: String, code: String, authToken: String?)
}

extension MailTarget: BaseTargetType {
    var path: String {
        switch self {
        case .sendCode:
            return "/user/send-email-code"
        case .verifyCode:
            return "/user/verify-email-code"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .sendCode(let email, let type):
            params["email"] = email
            params["type"] = type.rawValue
        case .verifyCode(let email, let code, let authToken):
            params["email"] = email
            params["code"] = code
            params["auth_token"] = authToken
        }
        return params
    }

}
