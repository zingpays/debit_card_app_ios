//
//  RegisterViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorTipsLabel: UILabel!
    @IBOutlet weak var codeInputView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var codeErrorTipsLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkDescTextView: UITextView!
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
    
    private let privacyPolicyKey = "PrivacyPolicy"
    private let termsAndConditionsKey = "TermsandConditions"
    
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
        self.gk_navRightBarButtonItem = loginItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        registerLabel.font = UIFont.fw.font28(type: .roboto, weight: .bold)
        registerLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        emailTextField.leftViewMode = .always
        codeTextField.leftViewMode = .always
        emailTextField.leftView = textFiledLeftView()
        codeTextField.leftView = textFiledLeftView()
        emailErrorTipsLabel.snp.remakeConstraints { make in
            make.height.equalTo(0)
        }
        codeErrorTipsLabel.snp.remakeConstraints { make in
            make.height.equalTo(0)
        }
        checkButton.setTitle("", for: .normal)
        setupCheckDescText()
    }
    
    private func setupCheckDescText() {
        let attrString = NSMutableAttributedString(string: checkDescTextView.text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let paragraphAttr:[NSAttributedString.Key:Any] = [.paragraphStyle:paragraphStyle,.font: UIFont.fw.font14(weight: .light)]
        attrString.addAttributes(paragraphAttr, range: NSRange(location: 0, length: checkDescTextView.text.count))
        let privacyPolicyString = "Privacy Policy"
        let termsAndConditionsString = "Terms and Conditions"
        let privacyPolicyRange = checkDescTextView.text.range(of: privacyPolicyString)
        let privacyPolicyLocation = checkDescTextView.text.distance(from: privacyPolicyString.startIndex, to: privacyPolicyRange!.lowerBound)
        let privacyPolicyStringRange = NSRange(location: privacyPolicyLocation, length: privacyPolicyString.count)
        attrString.addAttribute(.link, value: privacyPolicyKey, range: privacyPolicyStringRange)
        let termsAndConditionsRange = checkDescTextView.text.range(of: termsAndConditionsString)
        let termsAndConditionsLocation = checkDescTextView.text.distance(from: termsAndConditionsString.startIndex, to: termsAndConditionsRange!.lowerBound)
        let termsAndConditionsStringRange = NSRange(location: termsAndConditionsLocation, length: termsAndConditionsString.count)
        attrString.addAttribute(.link, value: termsAndConditionsKey, range: termsAndConditionsStringRange)
        checkDescTextView.attributedText = attrString
    }
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: emailTextField.height)))
    }

    // MARK: - Actions
    @objc private func loginAction() {
        
    }
    
    @IBAction func codeAction(_ sender: UIButton) {
        codeTextField.becomeFirstResponder()
    }
    
    @IBAction func agreementCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
    }
    
}

// MARK: - UITextViewDelegate

extension RegisterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.description == privacyPolicyKey {
            // TODO: Privacy Policy Action
        }
        if URL.description == termsAndConditionsKey {
            // TODO: Terms And Conditions Action
        }
        return false
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            codeTextField.becomeFirstResponder()
        }
        return true
    }
}
