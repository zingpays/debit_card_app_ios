//
//  SettingPasswordViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import SwifterSwift

class SettingPasswordViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.registerTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.settingYourPassword()
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = R.string.localizable.enterPassword()
        }
    }
    @IBOutlet weak var againPasswordTextField: UITextField! {
        didSet {
            againPasswordTextField.placeholder = R.string.localizable.enterPasswordAgain()
        }
    }
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
//    private lazy var loginItem: UIBarButtonItem = {
//        let btn = UIButton()
//        btn.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
//        btn.backgroundColor = R.color.fw00A8BB()
//        btn.layer.cornerRadius = 18
//        btn.setTitle(R.string.localizable.loginTitle(), for: .normal)
//        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
//        return UIBarButtonItem(customView: btn)
//    }()
    
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
//        setupRightItem()
        setupSubviews()
        setupTableview()
    }
    
//    private func setupRightItem() {
//        self.gk_navRightBarButtonItem = loginItem
//        self.gk_navItemRightSpace = 17
//    }
    
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
        if nextButton.alpha == 1 {
            requestRegister()
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
    
    private func requestRegister() {
        // TODO: register request
        // if fail, alert view
        // if success, go to  next page
        // save user token
        UserManager.shared.saveToken("i am a test token", expireDate: Date(timeIntervalSinceNow: 60*60*24*7))
        UserManager.shared.saveUserEmail("test@mail.com")
        LocalAuthenManager.shared.isAuthorized = true
        let vc = RegisterSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 >= 20 {
            return false
        } else {
            return true
        }
    }
    
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
        if textField == passwordTextField, textField.text?.count ?? 0 > 0 {
            tipsTableView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
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
        if textField == againPasswordTextField, textField.text?.count ?? 0 > 0 {
            againPasswordErrorTipsLabel.isHidden = textField.text == passwordTextField.text
        }
        inputViewEndEditing(textField)
    }

}
