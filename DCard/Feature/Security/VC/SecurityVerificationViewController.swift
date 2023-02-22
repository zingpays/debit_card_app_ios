//
//  SecurityVerificationViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SecurityVerificationType {
    case all
    case allWithoutAuthReset
    case email
    case twofa
    case phone
}

enum SecurityVerificationSource {
    case forgotPattern
    case changeEmail
    case closeAuth
    case forgotPassword
    case none
}

class SecurityVerificationViewController: BaseViewController {

    var style: SecurityVerificationType = .email
    var source: SecurityVerificationSource = .none
    var uniqueId: String?
    var authToken: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var securityTableView: UITableView!
    
    private lazy var footerView: UIView = {
        let v = UIView()
        v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 56))
        let btn = UIButton()
        v.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(26)
        }
        btn.layer.cornerRadius = 23
        btn.backgroundColor = R.color.fw00A8BB()
        if source == .forgotPattern {
            btn.setTitle(R.string.localizable.next(), for: .normal)
        } else {
            btn.setTitle(R.string.localizable.submit(), for: .normal)
        }
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return v
    }()
    
    private lazy var emailItem: SecurityVerificationItemModel = {
        let info = LocalizationManager.shared.currentLanguage() == .zh ? "输入6位已经发送到\(UserManager.shared.email ?? "")的验证码" : "Enter the 6-digit code sent to \(UserManager.shared.email ?? "")"
        let item = SecurityVerificationItemModel(title: R.string.localizable.emailVerificationCode(),
                                                      info: info,
                                                 inputPlaceholder: R.string.localizable.emialInputPlaceholder(),
                                                 style: .email)
        
        return item
    }()
    
    private lazy var phoneNumItem: SecurityVerificationItemModel = {
        let info = LocalizationManager.shared.currentLanguage() == .zh ? "输入6位发送到\(UserManager.shared.phoneNum ?? "")的验证码" : "Enter the 6 digit code sent to \(UserManager.shared.phoneNum ?? "")"
        let item = SecurityVerificationItemModel(title: R.string.localizable.phoneVerificationCode(),
                                                      info: info,
                                                 inputPlaceholder: R.string.localizable.phoneVerificationCodePlaceholder(),
                                                 style: .phone)
        return item
    }()
    
    private lazy var authItem: SecurityVerificationItemModel = {
        let item = SecurityVerificationItemModel(title: R.string.localizable.authenticatorCode(),
                                                 info: R.string.localizable.authenticatorCodeInfo(),
                                                 inputPlaceholder: R.string.localizable.authenticatorCodePlaceholder(),
                                                 style: .auth)
        
        return item
    }()
    
    private lazy var authWithoutResetItem: SecurityVerificationItemModel = {
        let item = SecurityVerificationItemModel(title: R.string.localizable.authenticatorCode(),
                                                 info: R.string.localizable.authenticatorCodeInfo(),
                                                 inputPlaceholder: R.string.localizable.authenticatorCodePlaceholder(),
                                                 style: .authWithoutReset)
        
        return item
    }()
    
    private lazy var datasource: [SecurityVerificationItemModel] = {
        switch style {
        case .all:
            return [emailItem, phoneNumItem, authItem]
        case .email:
            return [emailItem]
        case .twofa:
            return [authItem]
        case .phone:
            return [phoneNumItem]
        case .allWithoutAuthReset:
            return [emailItem, phoneNumItem, authWithoutResetItem]
        }
    }()
    
    private var authCode: String?
    private var emailCode: String?
    private var phoneCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        titleLabel.text = R.string.localizable.securityVerificationTitle()
        securityTableView.fw.registerCellNib(SecurityVerificationItemTableViewCell.self)
        securityTableView.tableFooterView = footerView
    }
    
    private func setupData() {
        if style == .email {
            requestSendEmailCode()
        }
    }
    
    // MARK: - Actions
    
    @objc private func nextAction() {
        if style == .email {
            
        }
        if style == .twofa {
            
        }
        switch style {
        case .all, .allWithoutAuthReset:
            requestAllVerify()
        case .email:
            requestMailVerify()
        case .twofa:
            requestAuthVerify()
        case .phone:
            print("")
        }
    }
    
    // MARK: - Network
    
    private func requestSendEmailCode() {
        indicator.startAnimating()
        MailRequest.sendCode(email: "", type: .login) { isSuccess, message in
            self.indicator.stopAnimating()
            if !isSuccess {
                self.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestMailVerify() {
        indicator.startAnimating()
        MailRequest.verifyCode(email: "", code: emailCode ?? "", authToken: "") { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                UIApplication.shared.keyWindow()?.rootViewController = nil
                UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestAuthVerify() {
        indicator.startAnimating()
        AuthRequest.verifyCode(uniqueId: uniqueId ?? "", authToken: authToken ?? "") { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                UIApplication.shared.keyWindow()?.rootViewController = nil
                UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestAllVerify() {
        // TODO: 成功后跳转新的页面
        // request ...
        if source == .forgotPattern {
            let vc = NineGraphLockScreenViewController()
            vc.style = .forgot
            vc.patternTitle = R.string.localizable.patternForgot()
            vc.tips = R.string.localizable.patternForgotTips()
            navigationController?.pushViewController(vc, animated: true)
        }
        if source == .changeEmail {
            let vc = ChangeEmailSuccessViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if source == .closeAuth {
            LockScreenManager.shared.isOn = false
            navigationController?.popViewController(animated: true)
        }
        if source == .forgotPassword {
            let vc = SettingPasswordViewController()
            vc.style = .forgot
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SecurityVerificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SecurityVerificationItemTableViewCell.height(style: datasource[indexPath.row].style)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: SecurityVerificationItemTableViewCell.self, for: indexPath)
        cell.upadateData(data: datasource[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
}

extension SecurityVerificationViewController: SecurityVerificationItemTableViewCellDelegate {
    func inputTextFieldEditing(_ text: String?, data: SecurityVerificationItemModel?) {
        switch data?.style {
        case .auth, .authWithoutReset:
            authCode = text
        case .email:
            emailCode = text
        case .phone:
            phoneCode = text
        case .none:
            break
        }
    }
    
    func didSelectedAuthUnavailable() {
        let alert = UIAlertController(title: R.string.localizable.tips(),
                                      message: R.string.localizable.resetAuthTips(),
                                      preferredStyle: .alert)
        let continuneAction = UIAlertAction(title: R.string.localizable.continue(),
                                            style: .default) { action in
            // TODO: go to reset authenticator
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(),
                                         style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(continuneAction)
        self.present(alert, animated: true)
    }
}
