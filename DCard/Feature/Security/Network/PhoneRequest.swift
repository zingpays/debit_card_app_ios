//
//  PhoneRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/24.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct PhoneRequest {
    static func sendCode(number: String,
                         completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PhoneTarget>()
        provider.requestStatus(.sendCode(number: number), completion: completion)
    }
    
    static func sendCheckCode(num: String,
                         completion: @escaping ResponseNormalCompletion) {
        let provider = MoyaProvider<PhoneTarget>()
        provider.requestStatus(.sendCheckCode(num: num), completion: completion)
    }
    
    static func setPhone(code: String, uniId: String, number: String, phoneCountryCode: String,
                         completion: @escaping ((Bool, String, LoginModel?) -> Void)) {
        let provider = MoyaProvider<PhoneTarget>()
        provider.requestObject(.setPhone(code: code, uniId: uniId, number: number, phoneCountryCode: phoneCountryCode),
                               type: LoginModel.self,
                               completion: completion)
    }
}

enum PhoneTarget {
    case sendCode(number: String)
    case sendCheckCode(num: String)
    case setPhone(code: String, uniId: String, number: String, phoneCountryCode: String)
}

extension PhoneTarget: BaseTargetType {
    var path: String {
        switch self {
        case .sendCode:
            return "/user/send-phone-code"
        case .setPhone:
            return "/user/set-phone"
        case .sendCheckCode:
            return "/user/send-code-for-set-phone"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .sendCode(let number):
            params["phone_number"] = number
        case .sendCheckCode(let num):
            params["phone_number"] = num
        case .setPhone(let code, let uniId, let number, let phoneCountryCode):
            params["phone_code"] = code
            params["user_id"] = uniId
            params["phone_number"] = number
            params["phone_country_code"] = phoneCountryCode
        }
        return params
    }

}
