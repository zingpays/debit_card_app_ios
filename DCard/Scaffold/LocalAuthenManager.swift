//
//  LocalAuthenManager.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/4.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import Foundation
import LocalAuthentication

let kBiometricsBindKey = "BIOMETRICSBINDKEY"

class LocalAuthenManager {
    
    static let shared = LocalAuthenManager()
    
    fileprivate let kEvaluatedPolicyDomainStateKey = "EVALUATEDPOLICYDOMAINSTATEKEY"
    
    private let context = LAContext()
    /// 是否可用，没有开启指纹或者面容，或者指纹或者面容不能工作
    var isAvailable = false
    /// 失败类型，如：kLAErrorAppCancel
    var errorCode: Int32 = 0
    /// 当前生物识别类型
    var type: LABiometryType = .none
    /// 是否已授权，锁屏只在冷启动重新弹出来
    var isAuthorized: Bool = false
    /// 是否已绑定
    var isBind: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kBiometricsBindKey)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kBiometricsBindKey)
        }
    }
    
    init() {
        var error: NSError? = nil
        isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        type = context.biometryType
        if let stateData = context.evaluatedPolicyDomainState {
            UserDefaults.standard.set(stateData, forKey: kEvaluatedPolicyDomainStateKey)
        }
        if let code = error?.code {
            errorCode = Int32(code)
        }
    }
    
    func evaluate(reply: @escaping (Bool, Int32) -> Void) {
        let localizedReason: String = {
            switch self.type {
            case .touchID:
                return R.string.localizable.localAuthenticationTouchIdLocalizedReason()
            case .faceID:
                return R.string.localizable.localAuthenticationFaceIdLocalizedReason()
            default:
                return " "
            }
        }()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { [weak self] isSuccess, err in
            guard let this = self else { return }
            this.isAuthorized = isSuccess
            let code: Int32 = {
                if let e = err as? NSError {
                    return Int32(e.code)
                } else {
                    return 0
                }
            }()
            reply(isSuccess, code)
        }
    }
    
    func isAvailableBiometrics() -> (Bool, Int32) {
        if context.evaluatedPolicyDomainState == UserDefaults.standard.value(forKey: kEvaluatedPolicyDomainStateKey) as? Data {
            return (isAvailable, errorCode)
        } else {
            return (false, errorCode)
        }
    }
    
}
