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
        view.backgroundColor = .brown
        let lockScreenVC = LockScreenViewController()
        lockScreenVC.modalPresentationStyle = .fullScreen
        self.present(lockScreenVC, animated: false)
    }
}
