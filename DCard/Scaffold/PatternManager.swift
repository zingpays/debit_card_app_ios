//
//  PatternManager.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/20.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation

class PatternManager {
    
    static let shared = PatternManager()
    fileprivate let kPatternPasswordKey = "PATTERNPASSWORDKEY"
    
    var password: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kPatternPasswordKey)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kPatternPasswordKey)
        }
    }
}
