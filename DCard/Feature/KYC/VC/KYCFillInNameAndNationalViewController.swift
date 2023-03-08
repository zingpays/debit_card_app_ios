//
//  KYCFillInNameAndNationalViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class KYCFillInNameAndNationalViewController: BaseViewController {
    
    var source: VerifyYourIdentitySource = .home
    
    var kycStatus: KycStatus = .notStarted
    
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipsTitleLabel: UILabel!
    @IBOutlet weak var tipsContentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var infoLabell: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var midleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var chooseNationalTextField: UITextField!
    @IBOutlet weak var continueNextButton: UIButton!
    @IBOutlet weak var nameTipsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleNameTipsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastNameTipsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nationalTipsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameErrorTipsLabel: UILabel!
    @IBOutlet weak var middleNameErrorTipsLabel: UILabel!
    @IBOutlet weak var lastNameErrorTipsLabel: UILabel!
    @IBOutlet weak var nationalErrorTipsLabel: UILabel!
    
    private var tipsCheckedDic: [Int : Bool] = [:]
    var datasource: [RegionModel] = []
    private var kycData: KYCModel?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupNavBar()
        setupSubviews()
    }
    
    private func setupData() {
        requestRegion()
        if kycStatus == .resubmitted {
            requestKycData()
        }
    }
    
    private func setupSubviews() {
        tipsViewHeightConstraint.constant = 0
        tipsViewTopConstraint.constant = 4 //default is 20
        tipsView.backgroundColor = R.color.fwED4949()?.withAlphaComponent(0.1)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        nameTextField.leftViewMode = .always
        nameTextField.leftView = textFiledLeftView()
        midleNameTextField.leftViewMode = .always
        midleNameTextField.leftView = textFiledLeftView()
        lastNameTextField.leftViewMode = .always
        lastNameTextField.leftView = textFiledLeftView()
        chooseNationalTextField.leftViewMode = .always
        chooseNationalTextField.leftView = textFiledLeftView()
        chooseNationalTextField.rightViewMode = .always
        chooseNationalTextField.rightView = textFieldRightView(#selector(chooseNationality))
        titleLabel.text = R.string.localizable.verifyYourIdentityTitle()
        subTitleLabel.text = R.string.localizable.tellYourNameAndNation()
        infoLabell.text = R.string.localizable.enterFullLegalNameTips()
        nameTextField.placeholder = R.string.localizable.enterYourName()
        midleNameTextField.placeholder = R.string.localizable.enterYourMiddleName()
        lastNameTextField.placeholder = R.string.localizable.enterYourLastName()
        chooseNationalTextField.placeholder = R.string.localizable.chooseYourNationality()
        continueNextButton.setTitle(R.string.localizable.continue(), for: .normal)
        tipsTitleLabel.text = R.string.localizable.reason()
    }
    
    private func textFieldRightView(_ action: Selector) -> UIView {
        let size = CGSize(width: 44, height: chooseNationalTextField.height)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        let btn = UIButton()
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 11), size: CGSize(width: 28, height: 28))
        btn.setImage(R.image.iconDownArrow(), for: .selected)
        btn.setImage(R.image.iconDownArrow(), for: .normal)
        v.addSubview(btn)
        return v
    }
    
    private func inputError(_ textField: UITextField) {
        textField.layer.borderColor = R.color.fwED4949()?.cgColor
        textField.layer.borderWidth = 2
    }
    
    private func inputBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.fw00A8BB()?.cgColor
        textField.layer.borderWidth = 2
    }
    
    private func inputEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        if nameTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[0] = true
        } else {
            tipsCheckedDic[0] = false
        }
        if lastNameTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[1] = true
        } else {
            tipsCheckedDic[1] = false
        }
        if chooseNationalTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[2] = true
        } else {
            tipsCheckedDic[2] = false
        }
        updateNextStatus()
    }
    
    @discardableResult
    private func updateNextStatus() -> Bool {
        var checkedCount = 0
        for (_, status) in tipsCheckedDic {
            if status {
                checkedCount += 1
            }
        }
        continueNextButton.alpha = checkedCount == 3 ? 1 : 0.4
        return checkedCount == 3
    }
    
    private func gotoRegionPage() {
        let vc = ChooseRegionViewController(style: .noCode)
        vc.pageTitle = R.string.localizable.chooseYourNationality()
        vc.datasource = datasource
        vc.style = .noCode
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                let text = {
                    var value = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
                    if value.isEmpty { value = data.nameEn ?? "" }
                    return value
                }()
                self.chooseNationalTextField.text = text
                self.inputEndEditing(self.chooseNationalTextField)
            }
        }
        self.present(vc, animated: true)
    }
    
    private func handleKycInfoAction(_ data: KYCModel?) {
        guard let kyc = data else { return }
        kycData = data
        nameTextField.text = kyc.firstName
        midleNameTextField.text = kyc.middleName
        lastNameTextField.text = kyc.lastName
        chooseNationalTextField.text = kyc.country
        inputEndEditing(nameTextField)
        if let resubmittedNote = data?.resubmittedNote, !resubmittedNote.isEmpty {
            tipsViewHeightConstraint.constant = 80
        } else {
            tipsViewHeightConstraint.constant = 0
        }
        if let resubmittedFidlds = data?.resubmittedFields {
            if resubmittedFidlds.firstName != nil {
                nameTipsHeightConstraint.constant = 16
                inputError(nameTextField)
                nameErrorTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                nameTipsHeightConstraint.constant = 0
            }
            if resubmittedFidlds.middleName != nil {
                middleNameTipsHeightConstraint.constant = 16
                inputError(midleNameTextField)
                middleNameErrorTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                middleNameTipsHeightConstraint.constant = 0
            }
            if resubmittedFidlds.lastName != nil {
                lastNameTipsHeightConstraint.constant = 16
                inputError(lastNameTextField)
                lastNameErrorTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                lastNameTipsHeightConstraint.constant = 0
            }
            if resubmittedFidlds.nationality != nil {
                nationalTipsHeightConstraint.constant = 16
                inputError(chooseNationalTextField)
                nationalErrorTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                nationalTipsHeightConstraint.constant = 0
            }
        }
    }
    
    // MARK: - Network
    
    private func requestKycData() {
        indicator.startAnimating()
        KYCRequest.info { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.handleKycInfoAction(data)
            } else {
                // TODO: 显示错误页面
            }
        }
    }
    
    private func requestRegion() {
        RegionRequest.list { isSuccess, message, list in
            if isSuccess, let regionList = list {
                self.datasource = regionList
            }
        }
    }
    
    private func requestSaveKYCStepOne(firstName: String, middleName: String?, lastName: String, nationality: String) {
        indicator.startAnimating()
        KYCRequest.saveStepOne(firstName: firstName,
                               middleName: middleName,
                               lastName: lastName,
                               nationality: nationality) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                let vc = FillInAddressViewController()
                vc.kycStatus = this.kycStatus
                vc.kycData = this.kycData
                this.navigationController?.pushViewController(vc, animated: true)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    // MARK: - Action
    
    @objc @IBAction func chooseNationality() {
        UIApplication.shared.keyWindow()?.endEditing(true)
        if datasource.isEmpty {
            indicator.startAnimating()
            RegionRequest.list { isSuccess, message, list in
                self.indicator.stopAnimating()
                if isSuccess, let regionList = list {
                    self.datasource = regionList
                    self.gotoRegionPage()
                }
            }
        } else {
            gotoRegionPage()
        }
    }
    
    @IBAction func continueNext(_ sender: UIButton) {
        guard sender.alpha == 1 else { return }
        guard let firstName = nameTextField.text,
                let middleName = midleNameTextField.text,
                let lastName = lastNameTextField.text,
                let nationality = chooseNationalTextField.text else { return }
        requestSaveKYCStepOne(firstName: firstName, middleName: middleName, lastName: lastName, nationality: nationality)
    }
    
}

// MARK: - UITextFieldDelegate
extension KYCFillInNameAndNationalViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing(textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputEndEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputEndEditing(textField)
    }
}

