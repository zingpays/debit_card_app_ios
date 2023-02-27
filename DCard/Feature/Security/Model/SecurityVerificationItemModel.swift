//
//  SecurityVerificationItemModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/14.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation

enum SecurityVerificationItemInfoStyle {
    case none
    case tips
    case error
}

enum SecurityVerificationGetCodeButtonStatus {
    case normal
    case countDown
}

class SecurityVerificationItemModel: NSObject {
    var title: String = ""
    var info: String = ""
    var text: String = ""
    var inputPlaceholder: String = ""
    var style: SecurityVerificationItemTableViewCellStyle = .email
    var infoStyle: SecurityVerificationItemInfoStyle = .none
    var getCodeButtonStatus: SecurityVerificationGetCodeButtonStatus = .normal
    
    init(title: String,
         info: String,
         text: String = "",
         inputPlaceholder: String,
         style: SecurityVerificationItemTableViewCellStyle = .email,
         infoStyle: SecurityVerificationItemInfoStyle = .none,
         getCodeButtonStatus: SecurityVerificationGetCodeButtonStatus = .normal) {
        self.title = title
        self.info = info
        self.inputPlaceholder = inputPlaceholder
        self.style = style
        self.infoStyle = infoStyle
    }
}
