//
//  AuthEmailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class AuthEmailViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.email()
        }
    }
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = UserManager.shared.email
        }
    }
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = R.string.localizable.securityChangeEmailInfoTips()
        }
    }
    @IBOutlet weak var changeEmailLabel: UILabel! {
        didSet {
            changeEmailLabel.text = R.string.localizable.securityChangeEmailButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
    }

    @IBAction func changeEmailAction(_ sender: Any) {
        let vc = SecurityVerificationViewController()
        vc.style = .allWithoutAuthReset
        vc.source = .changeEmail
        navigationController?.pushViewController(vc, animated: true)
    }
}
