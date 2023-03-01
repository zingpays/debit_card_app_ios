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
    static func verifyCode(uniqueId: String, authToken: String, completion: @escaping ((Bool, String, LoginModel?) -> Void)) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestObject(.verifyCode(uniqueId: uniqueId, authToken: authToken), type: LoginModel.self, completion: completion)
    }

    static func twofa(completion: @escaping ((Bool, String, TwoFactorAuthModel?) -> Void)) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestObject(.twofa, type: TwoFactorAuthModel.self, completion: completion)
    }
    
    static func setupTwofa(authCode: String, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestStatus(.settwofa(authCode: authCode), completion: completion)
    }
    
    static func unsetTwofa(emailCode: String,
                           phoneCode: String,
                           authCode: String,
                           completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestStatus(.unsetTwofa(emailCode: emailCode, phoneCode: phoneCode,authCode: authCode), completion: completion)
    }
    
    static func resetTwoFa(emailCode: String, phoneCode: String, authToken: String, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<AuthTarget>()
        provider.requestStatus(.resetTwoFa(emailCode: emailCode, phoneCode: phoneCode, authToken: authToken),
                               completion: completion)
    }
}

enum AuthTarget {
    case verifyCode(uniqueId: String, authToken: String)
    case twofa
    case settwofa(authCode: String)
    case unsetTwofa(emailCode: String, phoneCode: String, authCode: String)
    case resetTwoFa(emailCode: String, phoneCode: String, authToken: String)
}

extension AuthTarget: BaseTargetType {
    var path: String {
        switch self {
        case .verifyCode:
            return "/security/verify2fa"
        case .twofa:
            return "/user/twofa"
        case .settwofa:
            return "/security/set2fa"
        case .unsetTwofa:
            return "/security/unset2fa"
        case .resetTwoFa:
            return "/security/reset2fa"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .verifyCode(let uniqueId, let authToken):
            params["unique_id"] = uniqueId
            params["auth_token"] = authToken
        case .twofa:
            break
        case .settwofa(let authCode):
            params["secret"] = authCode
        case .unsetTwofa(let emailCode, let phoneCode, let authCode):
            params["email_code"] = emailCode
            params["phone_code"] = phoneCode
            params["one_time_password"] = authCode
        case .resetTwoFa(let emailCode, let phoneCode, let authCode):
            params["auth_token"] = authCode
            params["email_code"] = emailCode
            params["phone_code"] = phoneCode
        }
        return params
    }
}
