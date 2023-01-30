//
//  SecurityVerificationViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SecurityVerificationViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailDescLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verifyCodeLabel: UILabel!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var authTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        emailTextField.leftViewMode = .always
        emailTextField.leftView = textFiledLeftView()
        emailTextField.rightViewMode = .always
        emailTextField.rightView = textFieldRightView(#selector(emailCodeAction))
        verifyCodeTextField.leftViewMode = .always
        verifyCodeTextField.leftView = textFiledLeftView()
        verifyCodeTextField.rightViewMode = .always
        verifyCodeTextField.rightView = textFieldRightView(#selector(verifyCodeAction))
        authTextField.leftViewMode = .always
        authTextField.leftView = textFiledLeftView()
    }
    
    private func textFieldRightView(_ action: Selector) -> UIView {
        let size = CGSize(width: 86, height: 50)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        let btn = UIButton()
        btn.setTitle("Get Code", for: .normal)
        btn.titleLabel?.font = .fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 11), size: CGSize(width: 70, height: 28))
        v.addSubview(btn)
        return v
    }
    
    // MARK: - Actions
    @objc private func emailCodeAction() {
        
    }
    
    @objc private func verifyCodeAction() {
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = SettingNewPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
