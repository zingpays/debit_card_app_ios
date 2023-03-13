//
//  SettingPasswordViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import SwifterSwift

enum SettingPasswordStyle {
    case register
    case change
    case forgot
}

class SettingPasswordViewController: BaseViewController {
    
    private var email: String
    private var code: String
    var style: SettingPasswordStyle = .register
    var verifyCode: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var againPasswordErrorTipsLabel: UILabel! {
        didSet {
            againPasswordErrorTipsLabel.text = R.string.localizable.passwordsDoNotMatchTips()
        }
    }
    @IBOutlet weak var passwordErrorTipsLabel: UILabel! {
        didSet {
            passwordErrorTipsLabel.text = R.string.localizable.passwordFormatIsNotCorrect()
        }
    }
    @IBOutlet weak var tipsTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.next(), for: .normal)
        }
    }
    
    private let tipsDatas: [String] = {
        if LocalizationManager.shared.currentLanguage() == .zh {
            return ["8-20 个字符",
                    "至少包含一个大写字母",
                    "至少包含一个小写字母",
                    "至少包含一个数字",
                    "至少包含一个特殊字符"]
        } else {
            return ["8-20 characters",
                    "At least one uppercase letter",
                    "At least one lowercase letter",
                    "At least one digit",
                    "At least  one special characters"]
        }
    }()
    
    private var tipsCheckedDic: [Int : Bool] = [:]
    
    init(email: String = "", code: String = "") {
        self.email = email
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupTitle()
        setupSubviews()
        setupTableview()
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = UIFont.fw.font16()
        passwordTextField.leftViewMode = .always
        againPasswordTextField.leftViewMode = .always
        passwordTextField.rightViewMode = .whileEditing
        againPasswordTextField.rightViewMode = .whileEditing
        passwordTextField.leftView = textFiledLeftView()
        againPasswordTextField.leftView = textFiledLeftView()
        passwordTextField.rightView = textFieldRightView(#selector(passwordEyeAction))
        againPasswordTextField.rightView = textFieldRightView(#selector(againPasswordEyeAction))
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        againPasswordTextField.addTarget(self, action: #selector(againPasswordChanged), for: .editingChanged)
        passwordErrorTipsLabel.snp.remakeConstraints { make in
            make.height.equalTo(0)
            make.top.equalTo(passwordTextField.snp.bottom).offset(0)
        }
    }
    
    private func setupTitle() {
        switch style {
        case .register:
            titleLabel.text = R.string.localizable.registerTitle()
            subTitleLabel.text = R.string.localizable.settingYourPassword()
            passwordTextField.placeholder = R.string.localizable.enterPassword()
            againPasswordTextField.placeholder = R.string.localizable.enterPasswordAgain()
        case .change:
            titleLabel.text = R.string.localizable.securitySettingsChangePassword()
            subTitleLabel.text = R.string.localizable.settingYourPassword()
            passwordTextField.placeholder = R.string.localizable.enterPassword()
            againPasswordTextField.placeholder = R.string.localizable.enterPasswordAgain()
        case .forgot:
            titleLabel.text = R.string.localizable.forgotPasswordTitle()
            subTitleLabel.text = R.string.localizable.forgotPasswordSubTitle()
            passwordTextField.placeholder = R.string.localizable.newPassword()
            againPasswordTextField.placeholder = R.string.localizable.confirmNewPassword()
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
    
    private func setupTableview() {
        tipsTableView.fw.registerCellNib(SettingPasswordTipsTableViewCell.self)
    }
    
    private func hasUppercase(_ str: String) -> Bool {
        for c in str.charactersArray {
            if c.isUppercase {
                return true
            }
        }
        return false
    }
    
    private func hasLowercase(_ str: String) -> Bool {
        for c in str.charactersArray {
            if c.isLowercase {
                return true
            }
        }
        return false
    }
    
    func hasSpecialChar(_ string: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^0-9a-zA-Z\n ]", options: [])
        return regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) != nil
    }
    
    @discardableResult
    private func updateNextStatus() -> Bool {
        var checkedCount = 0
        for (_, status) in tipsCheckedDic {
            if status {
                checkedCount += 1
            }
        }
        nextButton.alpha = checkedCount == 6 ? 1 : 0.4
        return checkedCount == 6
    }
    
    private func checkPasswordFormat() -> Bool {
        var checkedCount = 0
        for (index, status) in tipsCheckedDic {
            if index < 5, status {
                checkedCount += 1
            }
        }
        return checkedCount == 5
    }
    
    private func inputBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.fw00A8BB()?.cgColor
        textField.layer.borderWidth = 2
    }
    
    private func inputViewEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    private func changedPasswordAction() {
        view.makeToast(R.string.localizable.changePasswordSuccessfully(), duration: 0.5, position: .center) { didTap in
            let email = UserManager.shared.email
            UserManager.shared.clearUserData()
            let vc = LoginViewController()
            vc.email = email
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        }
    }
    
    // MARK: - Network
    
    private func requestChangePassword(password: String, confirmPassword: String) {
        guard let verifyCode = verifyCode else { return }
        indicator.startAnimating()
        PasswordRequest.changePassword(password: password, confirmPassword: confirmPassword, verifyCode: verifyCode) { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.changedPasswordAction()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestForgotPassword(email: String,
                                       password: String,
                                       confirmPassword: String,
                                       verifyCode: String) {
        indicator.startAnimating()
        if UserManager.shared.token == nil {
            // 非登录态
            PasswordRequest.forgotPasswordNoLogin(email: email, password: password, verifyCode: verifyCode) { [weak self] isSuccess, message in
                guard let this = self else { return }
                this.indicator.stopAnimating()
                if isSuccess {
                    UserManager.shared.clearUserData()
                    UIApplication.shared.keyWindow()?.rootViewController = nil
                    let vc = LoginViewController()
                    let loginNavVC = UINavigationController(rootViewController: vc)
                    UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
                } else {
                    this.view.makeToast(message, position: .center)
                }
            }
        } else {
            PasswordRequest.forgotPassword(password: password,
                                           verifyCode: verifyCode) { [weak self] isSuccess, message in
                guard let this = self else { return }
                this.indicator.stopAnimating()
                if isSuccess {
                    UserManager.shared.clearUserData()
                    UIApplication.shared.keyWindow()?.rootViewController = nil
                    let vc = LoginViewController()
                    let loginNavVC = UINavigationController(rootViewController: vc)
                    UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
                } else {
                    this.view.makeToast(message, position: .center)
                }
            }
        }
        
        
    }
    
    // MARK: - Actions
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }

    @objc private func againPasswordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        againPasswordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func next(_ sender: UIButton) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        if nextButton.alpha == 1 {
            switch style {
            case .register:
                requestRegister(email: email, code: code, password: passwordTextField.text ?? "")
            case .change:
                guard let password = passwordTextField.text,
                      let confirmPassword = againPasswordTextField.text else { return }
                requestChangePassword(password: password, confirmPassword: confirmPassword)
            case .forgot:
                guard let password = passwordTextField.text,
                      let confirmPassword = againPasswordTextField.text,
                      let verifyCode = verifyCode else { return }
                requestForgotPassword(email: email, password: password, confirmPassword: confirmPassword, verifyCode: verifyCode)
            }
        }
    }
    
    @objc private func againPasswordChanged(_ sender: UITextField) {
        if passwordTextField.text == againPasswordTextField.text {
            tipsCheckedDic[5] = true
        } else {
            tipsCheckedDic[5] = false
        }
        updateNextStatus()
    }
    
    @objc private func passwordChanged(_ sender: UITextField) {
        let inputString = sender.text ?? ""
        if inputString.count >= 8 {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: true)
            tipsCheckedDic[0] = true
        } else {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: false)
            tipsCheckedDic[0] = false
        }
        if inputString.hasNumbers {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: true)
            tipsCheckedDic[3] = true
        } else {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: false)
            tipsCheckedDic[3] = false
        }
        if hasUppercase(inputString) {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: true)
            tipsCheckedDic[1] = true
        } else {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: false)
            tipsCheckedDic[1] = false
        }
        if hasLowercase(inputString) {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: true)
            tipsCheckedDic[2] = true
        } else {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: false)
            tipsCheckedDic[2] = false
        }
        if hasSpecialChar(inputString) {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: true)
            tipsCheckedDic[4] = true
        } else {
            let cell = tipsTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SettingPasswordTipsTableViewCell
            cell.updateStatus(isChecked: false)
            tipsCheckedDic[4] = false
        }
        updateNextStatus()
    }
    
    // MARK: - Network
    
    private func requestRegister(email: String, code: String, password: String) {
        indicator.startAnimating()
        RegisterRequest.register(email: email,
                                 password: passwordTextField.text ?? "",
                                 code:code) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                UserManager.shared.saveUserEmail(email)
                let vc = RegisterSuccessViewController()
                vc.uniqueId = data?.uniqueId
                this.navigationController?.pushViewController(vc, animated: true)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SettingPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: SettingPasswordTipsTableViewCell.self, for: indexPath)
        cell.descLabel.text = tipsDatas[indexPath.row]
        return cell
    }
    
}

// MARK: - UITextViewDelegate

extension SettingPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            if updateNextStatus() {
                againPasswordTextField.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        againPasswordErrorTipsLabel.isHidden = true
        if textField == passwordTextField {
            tipsTableView.snp.remakeConstraints { make in
                make.height.equalTo(120)
            }
            passwordErrorTipsLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(passwordTextField.snp.bottom).offset(0)
            }
        }
        if textField == againPasswordTextField {
            tipsTableView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
        inputBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            tipsTableView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
            if textField.text?.count ?? 0 > 0  {
                if !checkPasswordFormat() {
                    passwordErrorTipsLabel.snp.remakeConstraints { make in
                        make.height.equalTo(16)
                        make.top.equalTo(passwordTextField.snp.bottom).offset(12)
                    }
                } else {
                    passwordErrorTipsLabel.snp.remakeConstraints { make in
                        make.height.equalTo(0)
                        make.top.equalTo(passwordTextField.snp.bottom).offset(0)
                    }
                }
            }
        }
        if textField == againPasswordTextField, textField.text?.count ?? 0 > 0 {
            againPasswordErrorTipsLabel.isHidden = textField.text == passwordTextField.text
        }
        inputViewEndEditing(textField)
    }

}
