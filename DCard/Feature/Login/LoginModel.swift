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
    /// Token
    var accessToken: String = ""
    /// Token过期时间
    var accessTokenExpireDate: String?
    /// 用来刷新token的token
    var refreshToken: String = ""
    /// refresh Token过期时间
    var refreshTokenExpireDate: String?
    /// 是否需要更进一步验证，如验证码验证
    var furtherAuth: Bool = false
    /// 二次验证类型
    var authType: AuthType = .email
    /// 用户信息
    var user: UserModel?
    
    var authToken: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accessToken              <- map["access_token"]
        accessTokenExpireDate    <- map["access_token_expire_at"]
        refreshToken             <- map["refresh_token"]
        refreshTokenExpireDate   <- map["refresh_token_expire_at"]
        furtherAuth              <- map["further_auth"]
        authType                 <- map["auth_type"]
        authToken                <- map["auth_token"]
        user                     <- map["user"]
    }
}
