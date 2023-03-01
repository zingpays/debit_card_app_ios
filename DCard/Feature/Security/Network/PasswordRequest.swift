//
//  PasswordRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/27.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct PasswordRequest {
    static func verifyOldPassword(password: String,
                                  completion: @escaping ((Bool, String, VerifyMailModel?) -> Void)) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestObject(.verifyOldPassword(password: password), type: VerifyMailModel.self, completion: completion)
    }
    
    static func changePassword(password: String,
                               confirmPassword: String,
                               verifyCode: String,
                               completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestStatus(.changePassword(password: password, confirmPassword: confirmPassword, verifyCode: verifyCode),
                               completion: completion)
    }
}

enum PasswordTarget {
    case verifyOldPassword(password: String)
    case changePassword(password: String, confirmPassword: String, verifyCode: String)
}

extension PasswordTarget: BaseTargetType {
    var path: String {
        switch self {
        case .changePassword:
            return "/user/change-password2"
        case .verifyOldPassword:
            return "/user/change-password"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .verifyOldPassword(let password):
            params["current_password"] = password
        case .changePassword(let password, let confirmPassword, let verifyCode):
            params["password"] = password
            params["password_confirmation"] = confirmPassword
            params["verify_code"] = verifyCode
        }
        return params
    }
}
