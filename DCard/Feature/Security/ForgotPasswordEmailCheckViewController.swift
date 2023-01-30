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
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = SecurityVerificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
