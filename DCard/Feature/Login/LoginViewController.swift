//
//  LoginViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/18.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import SwiftDate

class LoginViewController: BaseViewController {
    
    private lazy var loginItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        btn.backgroundColor = R.color.fw00A8BB()
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font  = .fw.font16()
        btn.setTitle(R.string.localizable.registerTitle(), for: .normal)
        btn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
        setupData()
    }
    
    private func setupRightItem() {
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = loginItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        emailTextfield.leftViewMode = .always
        emailTextfield.leftView = textFiledLeftView()
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = textFiledLeftView()
        loginButton.titleLabel?.font = .fw.font16()
        loginButton.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.4)
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = textFieldRightView(#selector(passwordEyeAction))
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
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
    
    private func refreshLoginButton(isPass: Bool) {
        if isPass {
            loginButton.backgroundColor = R.color.fw00A8BB()
        } else {
            loginButton.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.4)
        }
    }
    
    private func setupData() {
        titleLabel.text = R.string.localizable.loginTitle()
        emailTextfield.placeholder = R.string.localizable.emialInputPlaceholder()
        passwordTextField.placeholder = R.string.localizable.passwordInputPlaceholder()
        forgotPasswordButton.setTitle(R.string.localizable.forgotPassword(), for: .normal)
        loginButton.setTitle(R.string.localizable.loginTitle(), for: .normal)
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
                          phone: loginData.user?.phoneNumber)
        } else {
            loginFinish(token: loginData.accessToken,
                        expireDate: loginData.accessTokenExpireDate ?? "",
                        email: loginData.user?.email ?? "",
                        phoneNum: loginData.user?.phoneNumber ?? "")
        }
    }
    
    private func continueLogin(authType: AuthType, authToken: String, uniqueId: String, email: String, phone: String?) {
        guard let email = emailTextfield.text else { return }
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
        }
    }
    
    private func inputBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.fw00A8BB()?.cgColor
        textField.layer.borderWidth = 2
    }
    
    private func inputEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
    }
    
    // MARK: - Actions
    
    @IBAction func emailInputEnd(_ sender: Any) {
        if let emailText = emailTextfield.text, !emailText.isValidEmail {
            view.makeToast(R.string.localizable.emailErrorTips(), duration: 1, position: .center)
        }
    }
    
    @IBAction func emailInputChanged(_ sender: UITextField) {
        let isPass = passwordTextField.text?.count ?? 0 > 0 && emailTextfield.text?.count ?? 0 > 0
        refreshLoginButton(isPass: isPass)
    }
    
    @objc private func registerAction() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordEmailCheckViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextField.text else { return }
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
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc private func passwordChanged(_ sender: UITextField) {
        let isPass = sender.text?.count ?? 0 > 0 && emailTextfield.text?.count ?? 0 > 0
        refreshLoginButton(isPass: isPass)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputEndEditing(textField)
    }
}
