//
//  UserManager.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/18.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Foundation
import SwifterSwift

// swiftlint:disable line_length
class UserManager {
    let TOKEN_KEY: String = "USER_TOKEN_KEY"
    let TOKEN_EXPIRE_DATE_KEY = "UESR_TOKEN_EXPIRE_DATE_KEY"
    let USER_EMAIL_KEY = "USER_EMAIL_KEY"
    let USER_PHONENUM_KEY = "USER_PHONENUM_KEY"
    let USER_INFO_KEY = "USER_INFO_KEY"
    
    static let shared = UserManager()
    
    /// 用户access token
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: TOKEN_KEY)
        }
    }
    /// 用户信息
//    var info: LoginModel? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: USER_INFO_KEY)
//            UserDefaults.standard.synchronize()
//        }
//        get {
//            let data = UserDefaults.standard.object(forKey: USER_INFO_KEY) as? LoginModel
//            return data
//        }
//    }
    
    /// Email
    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: USER_EMAIL_KEY)
        }
    }
    
    /// phone
    var phoneNum: String? {
        get {
            return UserDefaults.standard.string(forKey: USER_PHONENUM_KEY)
        }
    }
    
    func saveUserInfo(_ value: LoginModel) {
        UserDefaults.standard.set(value, forKey: USER_INFO_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveToken(_ value: String, expireDate: Date) {
        UserDefaults.standard.set(value, forKey: TOKEN_KEY)
        UserDefaults.standard.set(expireDate, forKey: TOKEN_EXPIRE_DATE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func isExpireToken() -> Bool {
        let date = UserDefaults.standard.date(forKey: TOKEN_EXPIRE_DATE_KEY)
        return date?.isInPast ?? true
    }
    
    func saveUserEmail(_ value: String) {
        UserDefaults.standard.set(value, forKey: USER_EMAIL_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveUserPhoneNum(_ value: String) {
        UserDefaults.standard.set(value, forKey: USER_PHONENUM_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: TOKEN_EXPIRE_DATE_KEY)
        UserDefaults.standard.removeObject(forKey: USER_PHONENUM_KEY)
        UserDefaults.standard.removeObject(forKey: USER_EMAIL_KEY)
        UserDefaults.standard.synchronize()
    }
    
}
