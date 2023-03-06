//
//  KYCRequest.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Moya
import Moya_ObjectMapper

struct KYCRequest {
    static func saveStepOne(firstName: String,
                            middleName: String?,
                            lastName: String,
                            nationality: String,
                            completion: @escaping ((Bool, String, KYCModel?) -> Void)) {
        let provider = MoyaProvider<KYCTarget>()
        provider.requestObject(.stepOne(firstName: firstName, middleName: middleName, lastName: lastName, nationality: nationality),
                               type: KYCModel.self,
                               completion: completion)
    }
    
    static func saveStepTwo(country: String,
                            state: String,
                            city: String,
                            address1: String,
                            address2: String?,
                            zipCode: String,
                            completion: @escaping ((Bool, String, KYCModel?) -> Void)) {
        let provider = MoyaProvider<KYCTarget>()
        provider.requestObject(.stepTwo(country: country, state: state, city: city, address1: address1, address2: address2, zipCode: zipCode),
                               type: KYCModel.self,
                               completion: completion)
    }
}

enum KYCTarget {
    case stepOne(firstName: String, middleName: String?, lastName: String, nationality: String)
    case stepTwo(country: String, state: String, city: String, address1: String, address2: String?, zipCode: String)
}

extension KYCTarget: BaseTargetType {
    var path: String {
        switch self {
        case .stepOne:
            return "/kyc/save-step1"
        case .stepTwo:
            return "/kyc/save-step2"
        }
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [:]
        switch self {
        case .stepOne(let firstName, let middleName, let lastName, let nationality):
            params["first_name"] = firstName
            params["middle_name"] = middleName
            params["last_name"] = lastName
            params["nationality"] = nationality
            params["date_of_birth"] = "1990-11-30"
            params["unique_id"] = "6648244"
        case .stepTwo(let country, let state, let city, let address1, let address2, let zipCode):
            params["country"] = country
            params["state"] = state
            params["city"] = city
            params["address1"] = address1
            params["address2"] = address2
            params["zipcode"] = zipCode
            params["unique_id"] = "6648244"
        }
        return params
    }
}
