//
//  BaseTargetType.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/15.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Moya

protocol BaseTargetType: TargetType {
    /// 参数
    var parameters: [String: Any]? { get }
    /// 是否需要Token，不需要授权参数的请返回false，如登录注册接口
    var needAuthorization: Bool { get }
}

extension BaseTargetType {
    var baseURL: URL {
        URL(string: "https://carddev.zingpays.com/app")!
    }

    var method: Moya.Method {
        return .post
    }

    var headers: [String: String]? {
        var params: [String: String] = [:]
        params["Accept"] = "application/json"
        if needAuthorization, let token = UserManager.shared.token {
            params["Authorization"] = "Bearer \(token)"
        }
        return params
    }

    var task: Task {
        guard let par = self.parameters else {
            return .requestPlain
        }
        return .requestParameters(parameters: par, encoding: URLEncoding.default)
    }

    var sampleData: Data {
        return Data()
    }

    var parameters: [String: Any]? {
        return nil
    }

    var needAuthorization: Bool {
        return true
    }
}
