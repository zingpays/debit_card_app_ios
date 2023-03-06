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
    
    private var tipsCheckedDic: [Int : Bool] = [:]
    var datasource: [RegionModel] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestRegion()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupNavBar()
        setupSubviews()
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
    
    private func requestRegion() {
        RegionRequest.list { isSuccess, message, list in
            if isSuccess, let regionList = list {
                self.datasource = regionList
            }
        }
    }
    
    private func gotoRegionPage() {
        let vc = ChooseRegionViewController(style: .noCode)
        vc.pageTitle = R.string.localizable.chooseYourNationality()
        vc.datasource = datasource
        vc.style = .noCode
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.updateNextStatus()
                self.chooseNationalTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
            }
        }
        self.present(vc, animated: true)
    }
    
    // MARK: - Network
    
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
                this.navigationController?.pushViewController(vc, animated: true)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    // MARK: - Action
    
    @objc @IBAction func chooseNationality() {
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
}

