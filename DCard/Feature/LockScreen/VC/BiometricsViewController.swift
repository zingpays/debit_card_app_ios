//
//  BiometricsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/19.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class BiometricsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAuth()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.gk_navLeftBarButtonItem = nil
    }
    
    private func startAuth() {
        if LocalAuthenManager.shared.isAvailable {
            LocalAuthenManager.shared.evaluate { isSuccess, errCode in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.dismiss(animated: false)
                    }
                } else {
                    DLog.info(errCode)
                }
            }
        } else {
            DLog.info(LocalAuthenManager.shared.errorCode)
        }
    }
    
}
