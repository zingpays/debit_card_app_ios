//
//  FilterModel.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation

struct FilterCardTypeModel {
    var type: String = R.string.localizable.virtualCard()
    var isSelected: Bool = false
}

class FilterTypeModel: NSObject {
    var type: TransactionType = .all
    var isSelected: Bool = false
    
    init(type: TransactionType = .all, isSelected: Bool = false) {
        self.type = type
        self.isSelected = isSelected
    }
}

class FilterDateModel: NSObject {
    var from: Date? = nil
    var to: Date? = nil
    
    init(from: Date? = nil, to: Date? = nil) {
        self.from = from
        self.to = to
    }
}
