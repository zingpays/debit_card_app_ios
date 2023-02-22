//
//  UserCenterViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/17.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController {

    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.backgroundColor = R.color.fwFFFFFF()
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font  = .fw.font16()
        btn.setImage(R.image.iconMore(), for: .normal)
        btn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var helloLabel: UILabel! {
        didSet {
            helloLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var securitySettingLabel: UILabel! {
        didSet {
            securitySettingLabel.text = R.string.localizable.securitySetting()
        }
    }
    @IBOutlet weak var languageTitleLabel: UILabel! {
        didSet {
            languageTitleLabel.text = R.string.localizable.language()
        }
    }
    @IBOutlet weak var languageLabel: UILabel! {
        didSet {
            languageLabel.text = LocalizationManager.shared.currentLanguage() == .zh ? "简体中文" : "English"
        }
    }
    @IBOutlet weak var contractUsLabel: UILabel! {
        didSet {
            contractUsLabel.text = R.string.localizable.contractUs()
        }
    }
    @IBOutlet weak var aboutLabel: UILabel! {
        didSet {
            aboutLabel.text = R.string.localizable.about()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusView.snp.remakeConstraints { make in
            make.width.equalTo(104)
        }
    }
    
    private func setupUI() {
        setupRightItem()
        updateSatusView()
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 17
    }
    
    private func updateSatusView() {
        // 根据状态来调整
        statusTextLabel.text = R.string.localizable.notVerified()
        avatorImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        verifiedImageView.snp.remakeConstraints { make in
            make.width.equalTo(0)
        }
        statusView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.16)
        statusTextLabel.textColor = R.color.fw76A4A7()
    }
    
    // MARK: - Network
    
    private func requestLogout() {
        UserManager.shared.removeToken()
        UIApplication.shared.keyWindow()?.rootViewController = nil
        let vc = LoginViewController()
        let loginNavVC = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
//        LoginRequest.logout { isSuccess, message in
//            if isSuccess {
//                UserManager.shared.removeToken()
//                UIApplication.shared.keyWindow()?.rootViewController = nil
//                let vc = LoginViewController()
//                let loginNavVC = UINavigationController(rootViewController: vc)
//                UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
//            }
//        }
    }
    
    // MARK: - Actions
    
    @objc private func moreAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let registerAction = UIAlertAction(title: R.string.localizable.logout(), style: .default) { _ in
            self.requestLogout()
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func statusAction(_ sender: Any) {
        
    }

    @IBAction func securitySettingAction(_ sender: Any) {
        let vc = SecuritySettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func languageAction(_ sender: Any) {
        let vc = LanguageSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contractUsAction(_ sender: Any) {
        let email = "support@flashwire.com"
        if let url = URL(string: "mailto:\(email)") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
