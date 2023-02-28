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
}

enum UserTarget {
    case loginInfo
    case securityStatus
    case status
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
        }
    }

    var parameters: [String: Any]? {
        return nil
    }
}

