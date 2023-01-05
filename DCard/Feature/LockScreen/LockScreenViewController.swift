//
//  LockScreenViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/5.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startAuth()
    }
    
    // MARK: - Private
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
    
    // MARK: - Actions
    
    @IBAction func unlock(_ sender: Any) {
        startAuth()
    }
}
