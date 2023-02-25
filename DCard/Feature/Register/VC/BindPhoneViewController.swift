//
//  BindPhoneViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/12.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class BindPhoneViewController: BaseViewController {

    var uniqueId: String?
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.toVerifyPhoneNumberTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.yourPhoneNumber()
        }
    }
    @IBOutlet weak var phoneInputView: UIView!
    @IBOutlet weak var infoLabell: UILabel! {
        didSet {
            infoLabell.text = R.string.localizable.yourPhoneNumberInfo()
        }
    }
    @IBOutlet weak var phoneRegionLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet {
            phoneTextField.placeholder = R.string.localizable.toVerifyPhoneNumberEnterYourNumber()
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setTitle(R.string.localizable.sendVerifyCode(), for: .normal)
        }
    }
    
    var datasource: [ChooseRegionModel] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestRegion()
    }
    
    override func setupNavBar() {}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneTextField.becomeFirstResponder()
    }

    // MARK: - Private
    
    private func setupUI() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        phoneTextField.addTarget(self, action: #selector(phoneNumValueChangeAction), for: .editingChanged)
    }
    
    private func gotoRegionPage() {
        let vc = ChooseRegionViewController()
        vc.pageTitle = R.string.localizable.chooseYourCountryTitle()
        vc.datasource = datasource
        vc.didSelectedCompletion = { data in
            self.phoneRegionLabel.text = data.subTitle
        }
        self.present(vc, animated: true)
    }
    
    // MARK: - Network
    
    private func requestRegion() {
        RegionRequest.list { isSuccess, message, list in
            if isSuccess, let regionList = list {
                for data in regionList {
                    let title = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
                    let region = ChooseRegionModel(title: title, subTitle: data.phoneCode ?? "")
                    self.datasource.append(region)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func phoneNumValueChangeAction() {
        if let text = phoneTextField.text, !text.isEmpty {
            sendButton.alpha = 1
        } else {
            sendButton.alpha = 0.4
        }
    }
    
    @IBAction func selectPhoneRegionAction(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        if datasource.isEmpty {
            RegionRequest.list { isSuccess, message, list in
                if isSuccess, let regionList = list {
                    for data in regionList {
                        let title = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
                        let region = ChooseRegionModel(title: title, subTitle: data.phoneCode ?? "")
                        self.datasource.append(region)
                    }
                }
                self.gotoRegionPage()
            }
        } else {
            gotoRegionPage()
        }
    }
    
    @IBAction func sendVerifyCode(_ sender: Any) {
        if sendButton.alpha == 1 {
            let phoneNum = "\(phoneRegionLabel.text ?? "")\(phoneTextField.text ?? "")"
            PhoneRequest.sendCode(number: phoneNum) { [weak self] isSuccess, message  in
                guard let this = self else { return }
                if isSuccess {
                    let vc = VerificationCodeViewController()
                    vc.phoneNum = phoneNum
                    vc.uniqueId = this.uniqueId
                    this.navigationController?.pushViewController(vc, animated: true)
                } else {
                    this.view.makeToast(message)
                }
            }
        }
    }
    
}
