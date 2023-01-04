//
//  HomeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testLocalAuth()
    }

    private func testLocalAuth() {
        if LocalAuthenManager.shared.isAvailable {
            LocalAuthenManager.shared.evaluate { isSuccess, errCode in
                if isSuccess {
                    LocalAuthenManager.shared.isAuthorized = true
                    print("success")
                } else {
                    switch errCode {
                    case kLAErrorAppCancel:
                        print("app cancel")
                    case kLAErrorUserCancel:
                        print("user cancel")
                    default:
                        print(errCode)
                    }
                }
            }
        } else {
            switch LocalAuthenManager.shared.errorCode {
            case kLAErrorTouchIDNotEnrolled, kLAErrorBiometryNotEnrolled:
                print("not enrolled")
            default:
                print("")
            }
            print("local auth is not available")
        }
    }
}
