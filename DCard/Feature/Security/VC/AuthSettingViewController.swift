//
//  AuthSettingViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/21.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class AuthSettingViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.patternAuthSettingTitle()
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = R.string.localizable.patternAuthSettingSubTitle()
        }
    }
    
    @IBOutlet weak var googleAuthLabel: UILabel! {
        didSet {
            googleAuthLabel.text = R.string.localizable.patternAuthSettingTitle()
        }
    }
    
    @IBOutlet weak var authSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authSwitch.isOn = LockScreenManager.shared.isOn
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(authSetupSuccess),
                                               name: Notification.Name(SETUPAUTHSUCCESS),
                                               object: nil)
    }

    // MARK: - Actions
    
    @IBAction func authAction(_ sender: UIButton) {
        if authSwitch.isOn {
            let vc = SecurityVerificationViewController()
            vc.style = .allWithoutAuthReset
            vc.source = .closeAuth
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = AuthSettingGuideViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func authSetupSuccess() {
        authSwitch.isOn = true
        LockScreenManager.shared.isOn = true
    }
}

