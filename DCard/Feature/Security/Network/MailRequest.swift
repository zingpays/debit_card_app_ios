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
    case resetEmail = "Reset Email"
    case transfer = "Transfer"
    case unsetTwoFa = "Unset Twofa"
    case resetTwoFa = "Reset Twofa"
    case forgotPassword = "Forgot Password"
}

struct MailRequest {
    static func sendCode(email: String,
                         type: MailCodeType,
                         completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.sendCode(email: email, type: type),
                               completion: completion)
    }
    
    static func verifyCode(email: String, code: String, authToken: String? = nil,
                           completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.verifyCode(email: email, code: code, authToken: authToken),
                               completion: completion)
    }
    
    static func setEmail(emailCode: String,
                         phoneCode: String,
                         authCode: String?,
                         completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.setEmail(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode),
                               completion: completion)
    }
    
    static func verifyEmail(email: String, code: String,
                            completion: @escaping ((Bool, String, VerifyMailModel?) -> Void)) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestObject(.verifyEmail(email: email, code: code), type: VerifyMailModel.self, completion: completion)
    }
    
    static func securityStatus(email: String, completion: @escaping ((Bool, String, SecurityStatusModel?) -> Void)) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestObject(.securityStatus(email: email), type: SecurityStatusModel.self, completion: completion)
    }
    
    static func verifyEmailForCard(code: String, completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<MailTarget>()
        provider.requestStatus(.verifyEmailForCard(code: code),
                               completion: completion)
    }
}

enum MailTarget {
    case sendCode(email: String, type: MailCodeType)
    case verifyCode(email: String, code: String, authToken: String?)
    case setEmail(emailCode: String, phoneCode: String, authCode: String?)
    case verifyEmail(email: String, code: String)
    case securityStatus(email: String)
    case verifyEmailForCard(code: String)
}

extension MailTarget: BaseTargetType {
    var path: String {
        switch self {
        case .sendCode:
            return "/user/send-email-code"
        case .verifyCode:
            return "/user/verify-email-code"
        case .setEmail:
            return "/user/set-email"
        case .verifyEmail:
            return "/user/verify-email"
        case .securityStatus:
            return "/user/get-user-by-email"
        case .verifyEmailForCard:
            return "/user/verify-email-for-card"
            
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
        case .setEmail(let emailCode, let phoneCode, let authCode):
            params["email_code"] = emailCode
            params["phone_code"] = phoneCode
            params["secret"] = authCode
        case .verifyEmail(let email, let code):
            params["email"] = email
            params["code"] = code
        case .securityStatus(let email):
            params["email"] = email
        case .verifyEmailForCard(let code):
            params["email_code"] = code
        }
        return params
    }

}
