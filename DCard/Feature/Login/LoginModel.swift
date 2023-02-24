//
//  LoginModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

enum AuthType: String {
    case email = "email"
    case googleAuth = "google authentication"
}

class LoginModel: Mappable {
    /// 用户Token
    var accessToken: String = ""
    /// 过期时间
    var expireAt: String?
    /// 是否需要更进一步验证，如验证码验证
    var furtherAuth: Bool = false
    /// 二次验证类型
    var authType: AuthType = .email
    /// 用户信息
    var user: UserModel?
    
    var authToken: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        expireAt    <- map["expire_at"]
        furtherAuth <- map["further_auth"]
        accessToken <- map["access_token"]
        authType    <- map["auth_type"]
        user        <- map["user"]
        authToken   <- map["auth_token"]
    }
}
