//
//  RegisterViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import SwifterSwift

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var registerLabel: UILabel! {
        didSet {
            registerLabel.text = R.string.localizable.registerTitle()
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = R.string.localizable.emialInputPlaceholder()
        }
    }
    @IBOutlet weak var emailErrorTipsLabel: UILabel!
    @IBOutlet weak var codeInputView: UIView!
    @IBOutlet weak var codeTextField: UITextField! {
        didSet {
            codeTextField.placeholder = R.string.localizable.enterVerificationCodePlaceholder()
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setTitle(R.string.localizable.getCode(), for: .normal)
        }
    }
    @IBOutlet weak var codeErrorTipsLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkDescTextView: UITextView! {
        didSet {
            checkDescTextView.text = R.string.localizable.agreement()
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.next(), for: .normal)
        }
    }
    
    private lazy var loginItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        btn.backgroundColor = R.color.fw00A8BB()
        btn.layer.cornerRadius = 18
        btn.setTitle(R.string.localizable.loginTitle(), for: .normal)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private let privacyPolicyKey = "PrivacyPolicy"
    private let termsAndConditionsKey = "TermsandConditions"
    private var tipsCheckedDic: [Int : Bool] = [:]
    private var time = DispatchSource.makeTimerSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: - Private
    
    private func setupData() {
        
    }
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
    }
    
    private func setupRightItem() {
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = loginItem
        self.gk_navItemRightSpace = 17
    }
    
    private func setupSubviews() {
        registerLabel.font = UIFont.fw.font28(type: .roboto, weight: .bold)
        registerLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
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
        let privacyPolicyString = LocalizationManager.shared.currentLanguage() == .zh ? "隐私政策" : "PrivacyPolicy"
        let termsAndConditionsString = LocalizationManager.shared.currentLanguage() == .zh ? "条款协议" : "TermsandConditions"
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
    
    private func checkCondition(_ textField: UITextField) {
        if textField == emailTextField {
            if let text = textField.text, !text.isEmpty, text.isValidEmail {
                tipsCheckedDic[0] = true
            } else {
                tipsCheckedDic[0] = false
            }
        }
        if textField == codeTextField {
            if let text = codeTextField.text, !text.isEmpty {
                tipsCheckedDic[1] = true
            } else {
                tipsCheckedDic[1] = false
            }
        }
        updateNextButtonStatus()
    }
    
    private func inputBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.layer.borderColor = R.color.fw00A8BB()?.cgColor
            emailTextField.layer.borderWidth = 2
            emailErrorTipsLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
        if textField == codeTextField {
            codeInputView.layer.borderColor = R.color.fw00A8BB()?.cgColor
            codeInputView.layer.borderWidth = 2
            codeErrorTipsLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    private func inputViewEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if let text = textField.text, !text.isEmpty, !text.isValidEmail {
                updateEmailErrorTips(R.string.localizable.emailIsIncorrectTips())
            } else {
                emailTextField.layer.borderWidth = 0
            }
        }
        if textField == codeTextField {
            codeInputView.layer.borderWidth = 0
        }
    }
    
    private func updateEmailErrorTips(_ text: String = "") {
        emailTextField.layer.borderColor = R.color.fwED4949()?.cgColor
        emailTextField.layer.borderWidth = 2
        emailErrorTipsLabel.text = text
        emailErrorTipsLabel.snp.remakeConstraints { make in
            make.height.equalTo(16)
        }
    }
    
    private func updateCodeErrorTips(_ text: String = "") {
        codeInputView.layer.borderColor = R.color.fwED4949()?.cgColor
        codeInputView.layer.borderWidth = 2
        codeErrorTipsLabel.text = text
        codeErrorTipsLabel.snp.remakeConstraints { make in
            make.height.equalTo(16)
        }
    }
    
    private func updateNextButtonStatus() {
        var checkedCount = 0
        for (_, status) in tipsCheckedDic {
            if status {
                checkedCount += 1
            }
        }
        nextButton.alpha = checkedCount == 3 ? 1 : 0.4
    }
    
    private func startCountDown() {
        var times = 60
        time.schedule(deadline: .now(), repeating: 1)
        time.setEventHandler { [weak self] in
            guard let this = self else { return }
            if times < 0 {
                DispatchQueue.main.async {
                    this.sendButton.alpha = 1
                    this.sendButton.setTitle(R.string.localizable.resend(), for: .normal)
                    this.time.cancel()
                }
            } else {
                DispatchQueue.main.async {
                    times -= 1
                    let text = LocalizationManager.shared.currentLanguage() == .zh ? "\(times)s后重新发送" : "Resend after \(times)s"
                    this.sendButton.alpha = 0.4
                    this.sendButton.setTitle(text, for: .normal)
                }
            }
        }
        time.resume()
    }

    // MARK: - Actions
    
    @objc private func loginAction() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func codeAction(_ sender: UIButton) {
        codeTextField.becomeFirstResponder()
        requestSendVerifyCode()
    }
    
    @IBAction func agreementCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tipsCheckedDic[2] = sender.isSelected
        updateNextButtonStatus()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if nextButton.alpha == 1 {
            // TODO: reuest check email code
            // if fail, alert view
            // if success, go to  next page
            let vc = SettingPasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Network
    
    private func requestSendVerifyCode() {
        // TODO: send code request
        // request success, then start count down
        startCountDown()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputViewEndEditing(textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkCondition(textField)
    }
}
