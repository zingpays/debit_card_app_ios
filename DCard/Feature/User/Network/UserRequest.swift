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
}

enum UserTarget {
    case loginInfo
}

extension UserTarget: BaseTargetType {
    var path: String {
        switch self {
        case .loginInfo:
            return "/user/login-info"
        }
    }

    var parameters: [String: Any]? {
        return nil
    }
}

