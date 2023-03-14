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
    
    static func securityVerify(email: String,
                               emailCode: String,
                               phoneCode: String?,
                               authCode: String?,
                               completion: @escaping ((Bool, String, VerifyMailModel?) -> Void)) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestObject(.securityVerify(email: email, emailCode: emailCode, phoneCode: phoneCode, authCode: authCode),
                               type: VerifyMailModel.self,
                               completion: completion)
    }
    
    static func forgotPassword(password: String,
                               verifyCode: String,
                               completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestStatus(.forgotPassword(password: password, verifyCode: verifyCode),
                               completion: completion)
    }
    
    static func forgotPasswordNoLogin(email: String,
                               password: String,
                               verifyCode: String,
                               completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestStatus(.forgotPasswordNoLogin(email: email, password: password, verifyCode: verifyCode),
                               completion: completion)
    }
    
    static func checkPassword(password: String,
                               completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PasswordTarget>()
        provider.requestStatus(.checkPassword(password: password),
                               completion: completion)
    }
}

enum PasswordTarget {
    case verifyOldPassword(password: String)
    case changePassword(password: String, confirmPassword: String, verifyCode: String)
    case securityVerify(email: String, emailCode: String?, phoneCode: String?, authCode: String?)
    case forgotPassword(password: String, verifyCode: String)
    case forgotPasswordNoLogin(email: String, password: String, verifyCode: String)
    case checkPassword(password: String)
}

extension PasswordTarget: BaseTargetType {
    var path: String {
        switch self {
        case .changePassword:
            return "/user/change-password2"
        case .verifyOldPassword:
            return "/user/change-password"
        case .securityVerify:
            return "/user/forgot-password"
        case .forgotPassword:
            return "/user/forgot-password2"
        case .forgotPasswordNoLogin:
            return "/user/forgot-password-no-login"
        case .checkPassword:
            return "/usert/check-password"
        }
    }
    
    var needAuthorization: Bool {
        switch self {
        case .securityVerify, .forgotPasswordNoLogin:
            return false
        default:
            return true
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
        case .securityVerify(let email, let emailCode, let phoneCode, let authCode):
            params["email"] = email
            params["email_code"] = emailCode
            params["phone_code"] = phoneCode
            params["secret"] = authCode
        case .forgotPassword(let password, let verifyCode):
            params["password"] = password
            params["verify_code"] = verifyCode
        case .forgotPasswordNoLogin(let email, let password, let verifyCode):
            params["email"] = email
            params["password"] = password
            params["verify_code"] = verifyCode
        case .checkPassword(let password):
            params["password"] = password
        }
        return params
    }
}
