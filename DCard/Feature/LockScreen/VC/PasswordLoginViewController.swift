//
//  PasswordLoginViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum LockScreenSource {
    case password
    case pattern
    case biometrics
    case cardDetail
    case none
}

class PasswordLoginViewController: BaseViewController {
    var source: LockScreenSource = .none
    /// 是否有存在切换其他方式的按钮
    var isHasChangeToOtherLoginMethod: Bool = false
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = R.string.localizable.enterPassword()
        }
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    private lazy var loginStatckView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .center
        return v
    }()
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
    private lazy var gestureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.setTitle(R.string.localizable.patternLogin(), for: .normal)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(gestureLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var biometricsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(biometricsLogin), for: .touchUpInside)
        if LocalAuthenManager.shared.type == .faceID {
            btn.setTitle(R.string.localizable.faceID(), for: .normal)
        }
        if LocalAuthenManager.shared.type == .touchID {
            btn.setTitle(R.string.localizable.touchID(), for: .normal)
        }
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
    }
    
    private func setupData() {
        emailLabel.text = UserManager.shared.email
        loginButton.setTitle(R.string.localizable.loginTitle(), for: .normal)
        forgotPasswordButton.setTitle(R.string.localizable.forgotPassword(), for: .normal)
        if source == .none {
            setupNotification()
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenUnlockSuccess),
                                               name: Notification.Name(UNLOCKSUCCESS),
                                               object: nil)
    }
    
    private func setupRightItem() {
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        emailLabel.font = UIFont.fw.font18()
        forgotPasswordButton.titleLabel?.font = UIFont.fw.font16()
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = textFiledLeftView()
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = textFieldRightView(#selector(passwordEyeAction))
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        if isHasChangeToOtherLoginMethod {
            view.addSubview(loginStatckView)
            var statckViewWidth = 0
            if LockScreenManager.shared.password != nil {
                statckViewWidth += 120 + 12
                loginStatckView.addArrangedSubview(gestureButton)
                gestureButton.snp.makeConstraints { make in
                    make.height.equalTo(30)
                    make.width.equalTo(120)
                }
            }
            if LocalAuthenManager.shared.isBind {
                statckViewWidth += 120
                loginStatckView.addArrangedSubview(biometricsButton)
                biometricsButton.snp.makeConstraints { make in
                    make.height.equalTo(30)
                    make.width.equalTo(120)
                }
            }
            loginStatckView.snp.remakeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(statckViewWidth)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-(24+TOUCHBARHEIGHT))
            }
        }
    }
    
    private func textFieldRightView(_ action: Selector) -> UIView {
        let size = CGSize(width: 44, height: passwordTextField.height)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        let btn = UIButton()
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 11), size: CGSize(width: 28, height: 28))
        btn.setImage(R.image.iconPasswordShow(), for: .selected)
        btn.setImage(R.image.iconPasswordHide(), for: .normal)
        v.addSubview(btn)
        return v
    }
    
    private func handleLogin(data: LoginModel?) {
        guard let loginData = data else {
            view.makeToast("data error~", position: .center)
            return
        }
        guard ((loginData.user?.phoneNumber) != nil), loginData.user?.phoneNumber?.count ?? 0 > 0 else {
            let vc = RegisterSuccessViewController()
            vc.uniqueId = loginData.user?.uniqueId
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if loginData.furtherAuth {
            continueLogin(authType: loginData.authType,
                          authToken: loginData.authToken ?? "",
                          uniqueId: loginData.user?.uniqueId ?? "",
                          email: loginData.user?.email ?? "",
                          phone: (loginData.user?.phoneCountryCode ?? "") + (loginData.user?.phoneNumber ?? ""))
        } else {
            loginFinish(token: loginData.accessToken,
                        expireDate: loginData.accessTokenExpireDate ?? "",
                        email: loginData.user?.email ?? "",
                        phoneNum: (loginData.user?.phoneCountryCode ?? "") + (loginData.user?.phoneNumber ?? ""))
        }
    }
    
    private func continueLogin(authType: AuthType, authToken: String, uniqueId: String, email: String, phone: String?) {
        let vc = SecurityVerificationViewController(email: email, phone: phone)
        vc.dataStyle = authType == .email ? [.email] : [.twofa]
        vc.source = authType == .email ? .loginViaEmail : .loginViaTwoFa
        vc.uniqueId = uniqueId
        vc.authToken = authToken
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginFinish(token: String, expireDate: String, email: String, phoneNum: String) {
        if let expireDate = expireDate.toDate()?.date {
            LocalAuthenManager.shared.isAuthorized = true
            // save user token
            UserManager.shared.saveToken(token, expireDate: expireDate)
            UserManager.shared.saveUserEmail(email)
            UserManager.shared.saveUserPhoneNum(phoneNum)
            // change application root viewController to tabbar viewController
            UIApplication.shared.keyWindow()?.rootViewController = nil
            UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
        } else {
            DLog.error("⚠️⚠️⚠️登录过期时间解析失败！")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordEmailCheckViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailLabel.text, let password = passwordTextField.text else { return }
        indicator.startAnimating()
        LoginRequest.login(email: email, password: password) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.handleLogin(data: data)
            } else {
                this.view.makeToast(message, duration: 1, position: .center)
            }
        }
    }
    
    @objc private func moreAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let switchAction = UIAlertAction(title: R.string.localizable.switchNewAccountLogin(), style: .default) { _ in
//            let vc = LoginViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        let registerAction = UIAlertAction(title: R.string.localizable.registerTitle(), style: .default) { _ in
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
//        alert.addAction(switchAction)
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc private func passwordChanged(_ sender: UITextField) {
        
    }
    /// 图案锁屏
    @objc private func gestureLogin() {
        switch source {
        case .pattern:
            navigationController?.popViewController()
        case .password, .cardDetail:
            break
        case .biometrics, .none:
            let vc = NineGraphLockScreenViewController()
            vc.source = .password
            vc.isHasChangeToOtherLoginMethod = true
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func biometricsLogin() {
        switch source {
        case .biometrics:
            navigationController?.popViewController()
        case .password, .cardDetail:
            break
        case .pattern, .none:
            let vc = BiometricsViewController()
            vc.source = .password
            vc.isHasChangeToOtherLoginMethod = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func screenUnlockSuccess() {
        self.dismiss(animated: true)
    }
}
