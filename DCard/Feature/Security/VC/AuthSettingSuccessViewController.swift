//
//  AuthSettingSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class AuthSettingSuccessViewController: BaseViewController {

    @IBOutlet weak var successLabel: UILabel! {
        didSet {
            successLabel.text = R.string.localizable.patternAuthSuccess()
        }
    }
    @IBOutlet weak var tipsLabel: UILabel! {
        didSet {
            tipsLabel.text = R.string.localizable.patternAuthSuccessTips()
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.gotIt(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gk_navLeftBarButtonItem = nil
    }

    @IBAction func gotItAction(_ sender: Any) {
        LockScreenManager.shared.isOn = true
        NotificationCenter.default.post(name: NSNotification.Name(SETUPAUTHSUCCESS), object: nil)
        if let vc = navigationController?.viewControllers.filter({ subVC in
            if subVC.isMember(of: AuthSettingViewController.self) {
                return true
            } else {
                return false
            }
        }).first {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}
