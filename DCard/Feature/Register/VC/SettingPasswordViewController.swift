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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var tipsTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private lazy var loginItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        btn.backgroundColor = R.color.fw00A8BB()
        btn.layer.cornerRadius = 18
        btn.setTitle("Login", for: .normal)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private let tipsDatas: [String] = {
        return ["8-20 characters",
                "At least one uppercase letter",
                "At least one lowercase letter",
                "At least one digit",
                "At least  one special characters"]
    }()
    
    private var tipsCheckedDic: [Int : Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
        setupRightItem()
        setupSubviews()
        setupTableview()
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 0.1
        view.layer.insertSublayer(bgLayer, at: 0)
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = loginItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(type: .roboto, weight: .bold)
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
    }
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: passwordTextField.height)))
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
    
    private func hasSpecialChar(_ str: String) -> Bool {
        let specStr = "-/:;()$&@\".,?!'[]{}#%￥^$<>|\\~+=-*€£"
        let set = CharacterSet(charactersIn: specStr)
        let range = str.rangeOfCharacter(from: set)
        return range != nil
    }
    
    @discardableResult
    private func updateNextStatus() -> Bool {
        var checkedCount = 0
        for (_, status) in tipsCheckedDic {
            if status {
                checkedCount += 1
            }
        }
        nextButton.alpha = checkedCount == 5 ? 1 : 0.4
        return checkedCount == 5
    }
    
    // MARK: - Actions
    
    @objc private func loginAction() {
        
    }
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }

    @objc private func againPasswordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        againPasswordTextField.isSecureTextEntry = !sender.isSelected
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
    }
    
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

}
