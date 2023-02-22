//
//  ChangePasswordViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.securitySettingsChangePassword()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.changePasswordSubTitle()
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = R.string.localizable.enterOldPassword()
        }
    }
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.setTitle(R.string.localizable.forgotPassword(), for: .normal)
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.next(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = textFiledLeftView()
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = textFieldRightView(#selector(passwordChanged))
    }
    
    private func textFieldRightView(_ action: Selector) -> UIView {
        let size = CGSize(width: 44, height: 50)
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
    
    @objc private func passwordChanged(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }

    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        if nextButton.alpha == 1 {
            let vc = SettingPasswordViewController()
            vc.style = .change
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordEmailCheckViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.isEmpty {
            nextButton.alpha = 0.4
        } else {
            nextButton.alpha = 1
        }
    }
}
