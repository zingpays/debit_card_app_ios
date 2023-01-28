//
//  PasswordLoginViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class PasswordLoginViewController: BaseViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    private lazy var loginStatckView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .center
        return v
    }()
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.backgroundColor = R.color.fwFFFFFF()
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font  = .fw.font16()
        btn.setImage(R.image.iconMore(), for: .normal)
        btn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    private lazy var gestureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.setTitle("Gesture Login", for: .normal)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(gestureLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var biometricsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(biometricsLogin), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
    }
    
    private func setupRightItem() {
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        emailLabel.font = UIFont.fw.font18()
        forgotPasswordButton.titleLabel?.font = UIFont.fw.font16()
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = textFiledLeftView()
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = textFieldRightView(#selector(passwordEyeAction))
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        view.addSubview(loginStatckView)
        loginStatckView.addArrangedSubview(gestureButton)
        gestureButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        var statckViewWidth = 160
        if LocalAuthenManager.shared.isBind {
            statckViewWidth += 100
            loginStatckView.addArrangedSubview(biometricsButton)
            biometricsButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(100)
            }
        }
        loginStatckView.snp.remakeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(statckViewWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(24+TOUCHBARHEIGHT))
        }
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
    
    @IBAction func loginAction(_ sender: Any) {
        
    }
    
    @objc private func moreAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let switchAction = UIAlertAction(title: "Switch New Account Login", style: .default) { _ in
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let registerAction = UIAlertAction(title: "Register", style: .default) { _ in
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(switchAction)
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func passwordEyeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc private func passwordChanged(_ sender: UITextField) {
        
    }
    
    @objc private func gestureLogin() {
        let vc = NineGraphLockScreenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func biometricsLogin() {
        // TODO: - 待定
    }
}
