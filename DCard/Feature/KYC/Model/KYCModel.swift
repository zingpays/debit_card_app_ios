//
//  KYCModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import ObjectMapper

struct KYCResubmittedFieldsModel: Mappable {
    var address1: String?
    var address2: String?
    var city: String?
    var country: String?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var nationality: String?
    var resubmittedNote: String?
    var state: String?
    var zipcode: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        address1         <- map["address1"]
        address2         <- map["address2"]
        city             <- map["city"]
        country          <- map["country"]
        firstName        <- map["first_name"]
        lastName         <- map["last_name"]
        middleName       <- map["middle_name"]
        nationality      <- map["nationality"]
        resubmittedNote  <- map["resubmitted_note"]
        state            <- map["state"]
        zipcode          <- map["zipcode"]
    }
}

struct KYCModel: Mappable {
    
    var address1: String?
    var address2: String?
    var approvedAt: String?
    var approvedBy: String?
    var city: String?
    var country: String?
    var createdAt: String?
    var enteredBy: String?
    var enteredNote: String?
    var faceStatus: String?
    var faceUrl: String?
    var firstName: String?
    var kycStatus: KycStatus?
    var lastName: String?
    var middleName: String?
    var nationality: String?
    var passportFile: String?
    var rejectNote: String?
    var rejectReason: String?
    var rejectedAt: String?
    var rejectedBy: String?
    var resubmittedAt: String?
    var resubmittedBy: String?
    var resubmittedNote: String?
    var selfieFile: String?
    var state: String?
    var submittedAt: String?
    var uniqueId: Int = 0
    var updatedAt: String?
    var zipcode: String?
    var veriffSession: KYCUrlSessionModel?
    var resubmittedFields: KYCResubmittedFieldsModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        address1           <- map["address1"]
        address2           <- map["address2"]
        approvedAt         <- map["approved_at"]
        approvedBy         <- map["approved_by"]
        city               <- map["city"]
        country            <- map["country"]
        createdAt          <- map["created_at"]
        enteredBy          <- map["entered_by"]
        enteredNote        <- map["entered_note"]
        faceStatus         <- map["face_status"]
        faceUrl            <- map["face_url"]
        firstName          <- map["first_name"]
        kycStatus          <- map["kyc_status"]
        lastName           <- map["last_name"]
        middleName         <- map["middle_name"]
        nationality        <- map["nationality"]
        passportFile       <- map["passport_file"]
        rejectNote         <- map["reject_note"]
        rejectReason       <- map["reject_reason"]
        rejectedAt         <- map["rejected_at"]
        rejectedBy         <- map["rejected_by"]
        resubmittedAt      <- map["resubmitted_at"]
        resubmittedBy      <- map["resubmitted_by"]
        resubmittedNote    <- map["resubmitted_note"]
        selfieFile         <- map["selfie_file"]
        state              <- map["state"]
        submittedAt        <- map["submitted_at"]
        uniqueId           <- map["unique_id"]
        updatedAt          <- map["updated_at"]
        zipcode            <- map["zipcode"]
        veriffSession      <- map["veriff_session"]
        resubmittedFields  <- map["resubmitted_fields"]
    }

}

