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
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        let vc = SecurityVerificationViewController(email: email)
        vc.dataStyle = [.email, .phone]
        vc.source = .forgotPassword
        navigationController?.pushViewController(vc, animated: true)
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
