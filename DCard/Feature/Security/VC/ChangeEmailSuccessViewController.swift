//
//  ChangeEmailSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ChangeEmailSuccessViewController: BaseViewController {
    
    var isFromResetTwoFa: Bool = false

    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.text = R.string.localizable.securityChangeEmailSuccessTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel!{
        didSet {
            subTitleLabel.text = R.string.localizable.securityChangeEmailSuccessSubTitle()
        }
    }
    @IBOutlet weak var contentLabel: UILabel!{
        didSet {
            contentLabel.text = R.string.localizable.securityChangeEmailSuccessContent()
        }
    }
    @IBOutlet weak var contactUsLabel: UILabel! {
        didSet {
            contactUsLabel.text = R.string.localizable.contractUs()
        }
    }
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton! {
        didSet {
            gotItButton.setTitle(R.string.localizable.gotIt(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavBar() {}
    // MARK: - Actions
    
    
    @IBAction func emailAction(_ sender: Any) {
        let email = "support@flashwire.com"
        if let url = URL(string: "mailto:\(email)") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = "support@flashwire.com"
    }
    
    @IBAction func gotItAction(_ sender: Any) {
        if isFromResetTwoFa {
            UserManager.shared.clearUserData()
            UIApplication.shared.keyWindow()?.rootViewController = nil
            let vc = LoginViewController()
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        } else {
            if let vc = navigationController?.viewControllers.filter({ subVC in
                if subVC.isMember(of: SecuritySettingsViewController.self) {
                    return true
                } else {
                    return false
                }
            }).first {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
