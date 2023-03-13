//
//  ForgotPasswordEmailCheckViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ForgotPasswordEmailCheckViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    
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
        emailTextField.delegate = self
        titleLabel.text = R.string.localizable.securityForgotPassword()
        subTitleLabel.text = R.string.localizable.securityForgotPasswordSubTitle()
        nextButton.setTitle(R.string.localizable.next(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        requestSecurityStatus()
    }
    
    // MARK: - Network
    
    private func requestSecurityStatus() {
        guard let email = emailTextField.text else { return }
        indicator.startAnimating()
        MailRequest.securityStatus(email: email) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess, let data = data {
                var styles: [SecurityVerificationType] = [.email]
                if data.phone?.status == true {
                    styles.append(.phone)
                }
                if data.twoFa?.status == true {
                    styles.append(.twofa)
                }
                let vc = SecurityVerificationViewController(email: email, phone: data.phone?.value)
                vc.dataStyle = styles
                vc.source = .forgotPassword
                vc.securityData = data
                this.navigationController?.pushViewController(vc, animated: true)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
}

extension ForgotPasswordEmailCheckViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.isEmpty {
            nextButton.alpha = 0.4
        } else {
            nextButton.alpha = 1
        }
    }
}
