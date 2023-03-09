//
//  UserRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

/// 登录接口
struct UserRequest {
    /// 用户登录信息
    /// - Parameters:
    ///   - completion: 完成回调
    static func loginInfo(completion: @escaping ((Bool, String, LoginInfoModel?) -> Void)) {
        let loginProvider = MoyaProvider<UserTarget>()
        loginProvider.requestObject(.loginInfo,
                                    type: LoginInfoModel.self,
                                    completion: completion)
    }
    
    static func securityStatus(completion: @escaping ((Bool, String, SecurityStatusModel?) -> Void)) {
        let loginProvider = MoyaProvider<UserTarget>()
        loginProvider.requestObject(.securityStatus,
                                    type: SecurityStatusModel.self,
                                    completion: completion)
    }
    
    static func status(completion: @escaping ((Bool, String, UserStatusModel?) -> Void)) {
        let loginProvider = MoyaProvider<UserTarget>()
        loginProvider.requestObject(.status,
                                    type: UserStatusModel.self,
                                    completion: completion)
    }
    
    static func securityCheck(emailCode: String?, phoneCode: String?, authCode: String?, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<UserTarget>()
        provider.requestStatus(.securityCheck(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode), completion: completion)
    }
}

enum UserTarget {
    case loginInfo
    case securityStatus
    case status
    case securityCheck(emailCode: String?, phoneCode: String?, authCode: String?)
}

extension UserTarget: BaseTargetType {
    var path: String {
        switch self {
        case .loginInfo:
            return "/user/login-info"
        case .securityStatus:
            return "/user/security-status"
        case .status:
            return "/user/status"
        case .securityCheck:
            return "/user/public-verify"
        }
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .securityCheck(let emailCode, let phoneCode, let authCode):
            params["email_code"] = emailCode
            params["phone_code"] = phoneCode
            params["secret"] = authCode
        default:
            break
        }
        return params
    }
}

