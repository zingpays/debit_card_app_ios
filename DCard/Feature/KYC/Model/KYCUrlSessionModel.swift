//
//  KYCUrlSessionModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct KYCUrlSessionModel: Mappable {
    
    var id: String?
    var host: String?
    var sessionToken: String?
    var status: String?
    var url: String?
    var vendorData: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        host         <- map["host"]
        id           <- map["id"]
        sessionToken <- map["sessionToken"]
        status       <- map["status"]
        url          <- map["url"]
        vendorData   <- map["vendorData"]
    }
}
