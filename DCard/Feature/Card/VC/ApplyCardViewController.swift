//
//  ApplyCardViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ApplyCardViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkDescTextView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    private let privacyPolicyKey = "PrivacyPolicy"
    private let termsAndConditionsKey = "TermsandConditions"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        titleLabel.text = R.string.localizable.applyCardTitle()
        subTitleLabel.text = R.string.localizable.applyCardSubTitle()
        infoLabel.text = R.string.localizable.applyCardInfo()
        continueButton.setTitle(R.string.localizable.continue(), for: .normal)
        checkButton.setTitle("", for: .normal)
        checkDescTextView.text = R.string.localizable.agreement()
        continueButton.alpha = 0.4
        setupCheckDescText()
    }
    
    private func setupCheckDescText() {
        let attrString = NSMutableAttributedString(string: checkDescTextView.text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let paragraphAttr:[NSAttributedString.Key:Any] = [.paragraphStyle:paragraphStyle,.font: UIFont.fw.font14(weight: .light)]
        attrString.addAttributes(paragraphAttr, range: NSRange(location: 0, length: checkDescTextView.text.count))
        let privacyPolicyString = LocalizationManager.shared.currentLanguage() == .zh ? "隐私政策" : "Privacy Policy"
        let termsAndConditionsString = LocalizationManager.shared.currentLanguage() == .zh ? "条款协议" : "Terms and Conditions"
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
    
    private func openCardSuccess() {
        let vc = ApplyCardSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Network
    
    private func requestOpenCard() {
        indicator.startAnimating()
        CardRequest.open { isSuccess, message in
            self.indicator.stopAnimating()
            if isSuccess {
                self.openCardSuccess()
            } else {
                self.view.makeToast(message, position: .center)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        guard checkButton.alpha == 1 else { return }
        requestOpenCard()
    }
    
    @IBAction func agreementCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        continueButton.alpha = sender.isSelected ? 1 : 0.4
    }
    
}
