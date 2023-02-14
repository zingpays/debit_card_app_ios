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
    }
    
    override func setupNavBar() {}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.isExpireToken() {
            UIApplication.shared.keyWindow()?.rootViewController = nil
            let vc = LoginViewController()
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        } else {
//            if LocalAuthenManager.shared.isBind && !LocalAuthenManager.shared.isAuthorized {
//                let lockScreenVC = BiometricsViewController()
//                let navVC = UINavigationController(rootViewController: lockScreenVC)
//                navVC.modalPresentationStyle = .fullScreen
//                self.present(navVC, animated: false)
//            } else if !LocalAuthenManager.shared.isAuthorized {
//                let vc = PasswordLoginViewController()
//                let navVC = UINavigationController(rootViewController: vc)
//                navVC.modalPresentationStyle = .fullScreen
//                self.present(navVC, animated: false)
//            }
        }
    }
}
