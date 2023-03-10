//
//  LockScreenManager.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/20.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation

class LockScreenManager {
    
    static let shared = LockScreenManager()
    fileprivate let kPatternPasswordKey = "PATTERNPASSWORDKEY"
    fileprivate let kAuthPasswordKey = "AUTHPASSWORDKEY"
    
    /// 九宫格图案
    var password: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kPatternPasswordKey)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kPatternPasswordKey)
        }
    }
    
    /// 是否开启了2FA
    var isOn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kAuthPasswordKey)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kAuthPasswordKey)
        }
    }
}
