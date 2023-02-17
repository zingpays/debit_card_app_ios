//
//  LoginRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

/// 登录接口
struct LoginRequest {
    /// 用户登录
    /// - Parameters:
    ///   - email: 邮件
    ///   - password: 密码
    ///   - completion: 完成回调
    static func login(email: String,
                      password: String,
                      completion: @escaping ((Bool, String, LoginModel?) -> Void)) {
        let loginProvider = MoyaProvider<LoginTarget>()
        loginProvider.requestObject(.login(email: email, password: password),
                                    type: LoginModel.self,
                                    completion: completion)
    }
    
    /// 注销登录
    static func logout(completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<LoginTarget>()
        provider.requestStatus(.logout, completion: completion)
    }
}

enum LoginTarget {
    case login(email: String, password: String)
    case logout
}

extension LoginTarget: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/auth-front/login"
        case .logout:
            return "/auth-front/logout"
        }
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .login(email: let email, password: let password):
            params["user_name"] = email
            params["password"] = password
        case .logout:
            break
        }
        return params
    }

    var needAuthorization: Bool {
        switch self {
        case .login:
            return false
        case .logout:
            return true
        }
    }
}
