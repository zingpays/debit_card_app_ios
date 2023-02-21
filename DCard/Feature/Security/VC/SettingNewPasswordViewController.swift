//
//  SettingNewPasswordViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SettingNewPasswordViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        newPasswordTextField.leftViewMode = .always
        newPasswordTextField.leftView = textFiledLeftView()
        newPasswordTextField.rightViewMode = .always
        newPasswordTextField.rightView = textFieldRightView(#selector(newPasswordEyeAction))
        confirmPasswordTextfield.leftViewMode = .always
        confirmPasswordTextfield.leftView = textFiledLeftView()
        confirmPasswordTextfield.rightViewMode = .always
        confirmPasswordTextfield.rightView = textFieldRightView(#selector(confirmPasswordChanged))
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
    
    // MARK: - Actions
    
    @objc private func newPasswordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPasswordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc private func confirmPasswordChanged(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPasswordTextfield.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
    }
    
}
