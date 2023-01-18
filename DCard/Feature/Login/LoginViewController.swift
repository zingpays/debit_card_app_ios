//
//  LoginViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/18.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private lazy var loginItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        btn.backgroundColor = R.color.fw00A8BB()
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font  = .fw.font16()
        btn.setTitle("Register", for: .normal)
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
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
        setupRightItem()
        setupSubviews()
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
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = loginItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        emailTextfield.leftViewMode = .always
        emailTextfield.leftView = textFiledLeftView()
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = textFiledLeftView()
        forgotPasswordButton.titleLabel?.font = .fw.font16()
        loginButton.titleLabel?.font = .fw.font16()
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = textFieldRightView(#selector(passwordEyeAction))
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 50)))
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
    
    // MARK: - Actions
    
    @objc private func registerAction() {
        // TODO: go to register
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
    }
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc private func passwordChanged(_ sender: UITextField) {
        
    }
}
