//
//  FillInAddressViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class FillInAddressViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressOneTextField: UITextField!
    @IBOutlet weak var addressTwoTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    private var tipsCheckedDic: [Int : Bool] = [:]

    /// data source
    var datasource: [RegionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        countryTextField.leftViewMode = .always
        countryTextField.leftView = textFiledLeftView()
        countryTextField.rightViewMode = .always
        countryTextField.rightView = textFieldRightView()
        stateTextField.leftViewMode = .always
        stateTextField.leftView = textFiledLeftView()
        stateTextField.rightViewMode = .always
        stateTextField.rightView = textFieldRightView()
        cityTextField.leftViewMode = .always
        cityTextField.leftView = textFiledLeftView()
        cityTextField.rightViewMode = .always
        cityTextField.rightView = textFieldRightView()
        addressOneTextField.leftViewMode = .always
        addressOneTextField.leftView = textFiledLeftView()
        addressTwoTextField.leftViewMode = .always
        addressTwoTextField.leftView = textFiledLeftView()
        postcodeTextField.leftViewMode = .always
        postcodeTextField.leftView = textFiledLeftView()
        titleLabel.text = R.string.localizable.verifyYourIdentityTitle()
        subTitleLabel.text = R.string.localizable.enterYourAddress()
        countryTextField.placeholder = R.string.localizable.chooseYourContryOfResidence()
        stateTextField.placeholder = R.string.localizable.chooseYourStateOfResidence()
        cityTextField.placeholder = R.string.localizable.chooseYourCityOfResidence()
        addressOneTextField.placeholder = R.string.localizable.enterYourDetailAddressOne()
        addressTwoTextField.placeholder = R.string.localizable.enterYourDetailAddressTwo()
        postcodeTextField.placeholder = R.string.localizable.enterYourPostCode()
        continueButton.setTitle(R.string.localizable.continue(), for: .normal)
    }
    
    private func setupData() {
        requestRegion()
    }
    
    private func textFieldRightView() -> UIView {
        let size = CGSize(width: 44, height: 50)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        let btn = UIButton()
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
        if countryTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[0] = true
        } else {
            tipsCheckedDic[0] = false
        }
        if stateTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[1] = true
        } else {
            tipsCheckedDic[1] = false
        }
        if cityTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[2] = true
        } else {
            tipsCheckedDic[2] = false
        }
        if addressOneTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[3] = true
        } else {
            tipsCheckedDic[3] = false
        }
        if postcodeTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[4] = true
        } else {
            tipsCheckedDic[4] = false
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
        continueButton.alpha = checkedCount == 5 ? 1 : 0.4
        return checkedCount == 5
    }
    
    private func gotoRegionPage() {
        let vc = ChooseRegionViewController(style: .noCode)
        vc.pageTitle = R.string.localizable.chooseYourContryOfResidence()
        vc.datasource = datasource
        vc.didSelectedCompletion = { data in
            self.countryTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
        }
        self.present(vc, animated: true)
    }
    
    // MARK: - Network
    
    private func requestRegion(isGotoAction: Bool = false) {
        if isGotoAction { indicator.startAnimating() }
        RegionRequest.list { isSuccess, message, list in
            self.indicator.stopAnimating()
            if isSuccess, let regionList = list {
                self.datasource = regionList
                if isGotoAction {
                    self.gotoRegionPage()
                }
            }
        }
    }
    
    private func requestSaveKYCStepTwo(country: String, state: String, city: String, zipCode: String, address1: String, address2: String?) {
        indicator.startAnimating()
        KYCRequest.saveStepTwo(country: country, state: state, city: city, address1: address1, address2: address2, zipCode: zipCode) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                let vc = KYCFinishViewController()
                this.navigationController?.pushViewController(vc, animated: true)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        guard let country = countryTextField.text,
                let state = stateTextField.text,
                let city = cityTextField.text,
                let zipCode = postcodeTextField.text,
                let address1 = addressOneTextField.text else { return }
        requestSaveKYCStepTwo(country: country, state: state, city: city, zipCode: zipCode, address1: address1, address2: addressTwoTextField.text)
    }
    
    @IBAction func countryAction(_ sender: Any) {
        if datasource.isEmpty {
            requestRegion(isGotoAction: true)
        } else {
            gotoRegionPage()
        }
    }
    
    @IBAction func stateAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        let vc = ChooseRegionViewController(style: .noCode)
//        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
//        vc.pageTitle = "choose your country"
//        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.stateTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func cityAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        let vc = ChooseRegionViewController(style: .noCode)
//        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
//        vc.pageTitle = "choose your country"
//        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.cityTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
            }
        }
        self.present(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension FillInAddressViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing(textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputEndEditing(textField)
    }
}
