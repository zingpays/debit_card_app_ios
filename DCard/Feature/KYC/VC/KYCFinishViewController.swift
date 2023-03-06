//
//  KYCFinishViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class KYCFinishViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var gitItButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.thanksForYourVerification()
        subTitleLabel.text = R.string.localizable.securityForgotPasswordSubTitle()
        gitItButton.setTitle(R.string.localizable.thanksForYourVerificationGotIt(), for: .normal)
    }
    
    // MARK: - Actions

    @IBAction func gotItAction(_ sender: Any) {
        if let vc = navigationController?.viewControllers.filter({ subVC in
            return subVC.isMember(of: HomeViewController.self)
        }).first {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}
