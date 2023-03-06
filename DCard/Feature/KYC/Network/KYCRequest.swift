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
}

enum KYCTarget {
    case stepOne(firstName: String, middleName: String?, lastName: String, nationality: String)
}

extension KYCTarget: BaseTargetType {
    var path: String {
        switch self {
        case .stepOne:
            return "/kyc/save-step1"
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
        }
        return params
    }
}
