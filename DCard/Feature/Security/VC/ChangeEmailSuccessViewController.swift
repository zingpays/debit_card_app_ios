//
//  ChangeEmailSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ChangeEmailSuccessViewController: BaseViewController {

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
    @IBOutlet weak var emailButton: UIButton! {
        didSet {
            emailButton.setTitle(UserManager.shared.email, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func emailAction(_ sender: Any) {
        
    }
    
    @IBAction func copyAction(_ sender: Any) {
        
    }
    
    @IBAction func gotItAction(_ sender: Any) {
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
