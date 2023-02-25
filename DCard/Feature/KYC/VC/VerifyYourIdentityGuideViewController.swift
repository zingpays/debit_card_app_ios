//
//  VerifyYourIdentityGuideViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum VerifyYourIdentitySource {
    case home
    case register
}

class VerifyYourIdentityGuideViewController: BaseViewController {
    
    var source: VerifyYourIdentitySource = .home

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.verifyYourIdentityTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.verifyYourIdentitySubTitle()
        }
    }
    @IBOutlet weak var informationRequireLabel: UILabel! {
        didSet {
            informationRequireLabel.text = R.string.localizable.informationRequired()
        }
    }
    @IBOutlet weak var fullNameAndNationalityLabel: UILabel! {
        didSet {
            fullNameAndNationalityLabel.text = R.string.localizable.fullNameAndNationality()
        }
    }
    @IBOutlet weak var passportLabel: UILabel! {
        didSet {
            passportLabel.text = R.string.localizable.passport()
        }
    }
    @IBOutlet weak var selfieLabel: UILabel! {
        didSet {
            selfieLabel.text = R.string.localizable.selfie()
        }
    }
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = R.string.localizable.address()
        }
    }
    @IBOutlet weak var veriftNowButton: UIButton! {
        didSet {
            veriftNowButton.setTitle(R.string.localizable.verifyNow(), for: .normal)
        }
    }
    /// Right item
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: SCREENWIDTH-40, y: 4, width: 36, height: 36)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 12
        btn.setTitle(R.string.localizable.skip(), for: .normal)
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = nil
        if source == .register {
            self.gk_navRightBarButtonItem = rightItem
            self.gk_navItemRightSpace = 16
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
    }

    // MARK: - Actions
    
    @IBAction func verifyNowAction(_ sender: Any) {
        let vc = KYCFillInNameAndNationalViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func skipAction() {
        // change application root viewController to tabbar viewController
        UIApplication.shared.keyWindow()?.rootViewController = nil
        UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
    }
}
