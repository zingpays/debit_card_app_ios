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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var accessImageView: UIImageView!
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
    
    private var kycStatus: KycStatus = .notStarted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupData() {
        indicator.startAnimating()
        UserRequest.status { isSuccess, message, data in
            self.indicator.stopAnimating()
            if isSuccess, let status = data?.kycStatus {
                self.updateKycStatus(status)
            } else {
                // ....
            }
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
        emailLabel.text = UserManager.shared.email
        helloLabel.text = R.string.localizable.hello()
        statusView.isHidden = true
        statusView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.16)
        statusTextLabel.textColor = R.color.fw76A4A7()
    }
    
    private func updateKycStatus(_ status: KycStatus) {
        UserManager.shared.kycStatus = status
        self.kycStatus = status
        // Not Verified: .notStarted, .start, .inProgress
        // Verification In Review: .submitted, .inReview
        // Resubmit Verification: .resubmitted
        // Verified: .approved
        // Rejected: .rejected
        statusView.isHidden = false
        var kycText = ""
        var bufferWidth: CGFloat = 0
        switch status {
        case .notStarted, .start, .inProgress:
            kycText = R.string.localizable.notVerified()
            verifiedImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            accessImageView.snp.remakeConstraints { make in
                make.width.equalTo(10)
            }
            statusView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.16)
            statusTextLabel.textColor = R.color.fw76A4A7()
            bufferWidth = 34
        case .submitted, .inReview:
            kycText = R.string.localizable.verificationInReview()
            verifiedImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            accessImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            statusView.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
            statusTextLabel.textColor = R.color.fw00A8BB()
            bufferWidth = 24
        case .approved:
            kycText = R.string.localizable.verified()
            verifiedImageView.snp.remakeConstraints { make in
                make.width.equalTo(16)
            }
            accessImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            statusView.backgroundColor = R.color.fw20B085()
            statusTextLabel.textColor = R.color.fwFFFFFF()
            bufferWidth = 38
        case .rejected:
            kycText = R.string.localizable.rejected()
            verifiedImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            accessImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            statusView.backgroundColor = R.color.fwED4949()
            statusTextLabel.textColor = R.color.fwFFFFFF()
            bufferWidth = 24
        case .resubmitted:
            kycText = R.string.localizable.resubmitVerification()
            verifiedImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            accessImageView.snp.remakeConstraints { make in
                make.width.equalTo(10)
            }
            statusView.backgroundColor = R.color.fwED4949()?.withAlphaComponent(0.1)
            statusTextLabel.textColor = R.color.fwED4949()
            bufferWidth = 34
        }
        let dic = [NSAttributedString.Key.font: UIFont.fw.font14()]
        let size = CGSize(width: CGFloat(MAXFLOAT), height: 20)
        let width = NSString(string: kycText).boundingRect(with: size,
                                     options: .usesLineFragmentOrigin,
                                     attributes: dic,
                                     context: nil).size.width
        let calWidth = width + bufferWidth
        statusView.snp.remakeConstraints { make in
            make.width.equalTo(calWidth)
        }
        statusTextLabel.text = kycText
        accessImageView.image = status == .resubmitted ? R.image.iconRightArrowRed() : R.image.iconRightArrowGreen()
    }
    
    // MARK: - Network
    
    private func requestLogout() {
        LoginRequest.logout { isSuccess, message in
            if isSuccess {
                UserManager.shared.clearUserData()
                UIApplication.shared.keyWindow()?.rootViewController = nil
                let vc = LoginViewController()
                let loginNavVC = UINavigationController(rootViewController: vc)
                UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
            } else {
                self.view.makeToast(message, position: .center)
            }
        }
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
        let vc = KYCUnAvailableViewController()
        vc.source = .userCenter
        vc.kycStatus = kycStatus
        navigationController?.pushViewController(vc, animated: true)
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
