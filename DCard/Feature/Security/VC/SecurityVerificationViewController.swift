//
//  SecurityVerificationViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SecurityVerificationType {
    case email
    case twofa
    case phone
    case twofaWithoutReset
}

enum SecurityVerificationSource {
    case forgotPattern
    case changeEmail
    case closeAuth
    case forgotPassword
    case login
    case none
}

class SecurityVerificationViewController: BaseViewController {
    
    var email: String
    var dataStyle: [SecurityVerificationType] = []
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
        switch source {
        case .forgotPattern, .changeEmail:
            btn.setTitle(R.string.localizable.next(), for: .normal)
        case .closeAuth, .forgotPassword, .login, .none:
            btn.setTitle(R.string.localizable.submit(), for: .normal)
        }
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return v
    }()
    
    private lazy var emailItem: SecurityVerificationItemModel = {
        let info = LocalizationManager.shared.currentLanguage() == .zh ? "输入6位已经发送到\(self.email)的验证码" : "Enter the 6-digit code sent to \(self.email)"
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
                                                 style: .auth,
                                                 infoStyle: .tips)
        
        return item
    }()
    
    private lazy var authWithoutResetItem: SecurityVerificationItemModel = {
        let item = SecurityVerificationItemModel(title: R.string.localizable.authenticatorCode(),
                                                 info: R.string.localizable.authenticatorCodeInfo(),
                                                 inputPlaceholder: R.string.localizable.authenticatorCodePlaceholder(),
                                                 style: .authWithoutReset,
                                                 infoStyle: .tips)
        
        return item
    }()
    
    private lazy var datasource: [SecurityVerificationItemModel] = {
        var list: [SecurityVerificationItemModel] = []
        for style in dataStyle {
            switch style {
            case .email:
                list.append(emailItem)
            case .twofa:
                list.append(authItem)
            case .phone:
                list.append(phoneNumItem)
            case .twofaWithoutReset:
                list.append(authWithoutResetItem)
            }
        }
        return list
    }()
    
    private var authCode: String?
    private var emailCode: String?
    private var phoneCode: String?
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
    }
    
    private func securityVerifySuccessAction() {
        switch source {
        case .forgotPattern:
            print("")
        case .changeEmail:
            let vc = ChangeEmailSuccessViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .closeAuth:
            if let vc = navigationController?.viewControllers.filter({ subVC in
                if subVC.isMember(of: AuthSettingViewController.self) {
                    return true
                } else {
                    return false
                }
            }).first {
                navigationController?.popToViewController(vc, animated: true)
            }
        case .forgotPassword:
            print("")
        case .login:
            print("")
        case .none:
            print("")
        }
    }
    
    // MARK: - Actions
    
    @objc private func nextAction() {
        switch source {
        case .forgotPattern:
            let vc = SettingNewPasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .changeEmail:
            guard let emailCode = emailCode,
                  let phoneCode = phoneCode else { return }
            requestSecurityVerify(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode)
        case .closeAuth:
            guard let emailCode = emailCode,
                  let phoneCode = phoneCode,
                  let authCode = authCode else { return }
            requestUnsetTwofa(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode)
        case .forgotPassword:
            print("")
        case .login:
            requestMailVerify()
        case .none:
            print("")
        }
    }
    
    // MARK: - Network
    
    private func requestSendEmailCode(_ email: String) {
        indicator.startAnimating()
        let type: MailCodeType = {
            switch source {
            case .forgotPattern:
                return .login
            case .changeEmail:
                return .resetEmail
            case .closeAuth:
                return .unsetTwoFa
            case .forgotPassword:
                return .individual
            case .login:
                return .login
            case .none:
                return .individual
            }
        }()
        MailRequest.sendCode(email: email, type: type) { isSuccess, message in
            self.indicator.stopAnimating()
            if isSuccess {
                for item in self.datasource {
                    if item.style == .email {
                        item.infoStyle = .tips
                        item.getCodeButtonStatus = .countDown
                    }
                }
            } else {
                for item in self.datasource {
                    if item.style == .email {
                        item.infoStyle = .error
                        item.info = message
                    }
                }
            }
            self.securityTableView.reloadData()
        }
    }
    
    private func requestSendPhoneCode(_ num: String) {
        indicator.startAnimating()
        PhoneRequest.sendCode(number: num) { isSuccess, message in
            self.indicator.stopAnimating()
            if isSuccess {
                for item in self.datasource {
                    if item.style == .phone {
                        item.infoStyle = .tips
                        item.getCodeButtonStatus = .countDown
                    }
                }
            } else {
                for item in self.datasource {
                    if item.style == .phone {
                        item.infoStyle = .error
                        item.info = message
                    }
                }
            }
            self.securityTableView.reloadData()
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
    
    private func requestSecurityVerify(emailCode: String, phoneCode: String, authCode: String?) {
        indicator.startAnimating()
        MailRequest.setEmail(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode) { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.securityVerifySuccessAction()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestUnsetTwofa(emailCode: String, phoneCode: String, authCode: String) {
        indicator.startAnimating()
        AuthRequest.unsetTwofa(emailCode: emailCode, phoneCode: phoneCode, authCode: authCode) { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                LockScreenManager.shared.isOn = false
                this.navigationController?.popViewController()
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
        if source == .changeEmail {
            
        }
    }
}

extension SecurityVerificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = datasource[indexPath.row]
        return SecurityVerificationItemTableViewCell.height(style: data.style, infoStyle: data.infoStyle)
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
    func didSelectedAuthUnavailable(_ cell: SecurityVerificationItemTableViewCell) {
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
    
    func didSelectedSendCode(_ cell: SecurityVerificationItemTableViewCell, data: SecurityVerificationItemModel) {
        switch data.style {
        case .email:
            requestSendEmailCode(email)
        case .phone:
            guard let phone = UserManager.shared.phoneNum, !phone.isEmpty else { return }
            requestSendPhoneCode(phone)
        case .auth, .authWithoutReset:
            break
        }
    }
    
    func inputTextFieldEditing(_ cell: SecurityVerificationItemTableViewCell, _ text: String?, data: SecurityVerificationItemModel?) {
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
    
}
