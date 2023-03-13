//
//  FillInAddressViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import Veriff

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
    
    @IBOutlet weak var countryTipsLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var stateTipsLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityTipsLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var address1TipsLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var address2TipsLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var postcodeTipsLabelConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var countryTipsLabel: UILabel!
    @IBOutlet weak var stateTipsLabel: UILabel!
    @IBOutlet weak var cityTipsLabel: UILabel!
    @IBOutlet weak var address1TipsLabel: UILabel!
    @IBOutlet weak var address2TipsLabel: UILabel!
    @IBOutlet weak var postcodeTipsLabel: UILabel!
    
    private var tipsCheckedDic: [Int : Bool] = [:]
    
    private var countryCode: Int? = 0
    private var stateCode: Int?
    var kycStatus: KycStatus = .notStarted
    var kycData: KYCModel?
    
    private let configuration: VeriffSdk.Configuration = {
        let branding = VeriffSdk.Branding()
        branding.logo = UIImage(named: "AppIcon.png")
        let identif = LocalizationManager.shared.currentLanguage() == .zh ? "Zh" : "en"
        let locale = Locale(identifier: identif)
        let config = VeriffSdk.Configuration(branding: branding, languageLocale: locale)
        return config
    }()
    
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
        requestRegion(title: R.string.localizable.chooseYourContryOfResidence(), actionTextField: countryTextField)
        if kycStatus == .resubmitted {
            guard let data = kycData?.resubmittedFields else { return }
            countryTextField.text = kycData?.country
            stateTextField.text = kycData?.state
            cityTextField.text = kycData?.city
            addressOneTextField.text = kycData?.address1
            addressTwoTextField.text = kycData?.address2
            postcodeTextField.text = kycData?.zipcode
            inputEndEditing(countryTextField)
            if let country = kycData?.country {
                RegionRequest.info(name: country) { isSuccess, _, data in
                    if isSuccess { self.countryCode = data?.id }
                }
            }
            if let state = kycData?.state {
                RegionRequest.info(name: state) { isSuccess, _, data in
                    if isSuccess { self.stateCode = data?.id }
                }
            }
            if data.country != nil {
                countryTipsLabelConstraint.constant = 16
                inputError(countryTextField)
                countryTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                countryTipsLabelConstraint.constant = 0
            }
            if data.state != nil {
                stateTipsLabelConstraint.constant = 16
                inputError(stateTextField)
                stateTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                stateTipsLabelConstraint.constant = 0
            }
            if data.city != nil {
                cityTipsLabelConstraint.constant = 16
                inputError(cityTextField)
                cityTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                cityTipsLabelConstraint.constant = 0
            }
            if data.address1 != nil {
                address1TipsLabelConstraint.constant = 16
                inputError(addressOneTextField)
                address1TipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                address1TipsLabelConstraint.constant = 0
            }
            if data.address2 != nil {
                address2TipsLabelConstraint.constant = 16
                inputError(addressTwoTextField)
                address2TipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                address2TipsLabelConstraint.constant = 0
            }
            if data.zipcode != nil {
                postcodeTipsLabelConstraint.constant = 16
                inputError(postcodeTextField)
                postcodeTipsLabel.text = R.string.localizable.resubmitErrorTips()
            } else {
                postcodeTipsLabelConstraint.constant = 0
            }
        }
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
        if textField == countryTextField { countryTipsLabelConstraint.constant = 0 }
        if textField == stateTextField { stateTipsLabelConstraint.constant = 0 }
        if textField == cityTextField { cityTipsLabelConstraint.constant = 0 }
        if textField == addressOneTextField { address1TipsLabelConstraint.constant = 0 }
        if textField == addressTwoTextField { address2TipsLabelConstraint.constant = 0 }
        if textField == postcodeTextField { postcodeTipsLabelConstraint.constant = 0 }
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
    
    private func gotoRegionPage(title: String, actionTextField: UITextField, datas: [RegionModel]) {
        let vc = ChooseRegionViewController(style: .noCode)
        vc.pageTitle = title
        vc.datasource = datas
        vc.didSelectedCompletion = { [weak self] data in
            guard let this = self else { return }
            let text = {
                var value = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
                if value.isEmpty { value = data.nameEn ?? "" }
                return value
            }()
            actionTextField.text = text
            if actionTextField == this.countryTextField {
                this.countryCode = data.id
                this.stateTextField.text = nil
                this.cityTextField.text = nil
            }
            if actionTextField == this.stateTextField { this.stateCode = data.id }
            this.inputEndEditing(actionTextField)
        }
        self.present(vc, animated: true)
    }
    
    private func handleVeriffAction() {
        indicator.startAnimating()
        KYCRequest.urlSession { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess, let sessionUrl = data?.url {
                DispatchQueue.main.async {
                    let veriff = VeriffSdk.shared
                    veriff.delegate = self
                    veriff.startAuthentication(sessionUrl: sessionUrl, configuration: this.configuration, presentingFrom: this)
                }
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func inputError(_ textField: UITextField) {
        textField.layer.borderColor = R.color.fwED4949()?.cgColor
        textField.layer.borderWidth = 2
    }
    
    // MARK: - Network
    
    private func requestRegion(id: Int? = nil, isGotoAction: Bool = false, title: String, actionTextField: UITextField) {
        if isGotoAction { indicator.startAnimating() }
        RegionRequest.list(id: id) { isSuccess, message, list in
            self.indicator.stopAnimating()
            if isSuccess, let regionList = list {
                if actionTextField == self.countryTextField {
                    self.datasource = regionList
                }
                if isGotoAction {
                    self.gotoRegionPage(title: title, actionTextField: actionTextField, datas: regionList)
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
                this.requestStatus()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestSaveKYCStepThree(isVeriffPass: Bool) {
        indicator.startAnimating()
        let veriffSubmitted = isVeriffPass ? "Yes" : "No"
        KYCRequest.saveStepThree(veriffSubmitted: veriffSubmitted) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.submitRequest()
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func submitRequest() {
        indicator.startAnimating()
        KYCRequest.submit { isSuccess, message in
            if isSuccess {
                let vc = KYCFinishViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestStatus() {
        indicator.startAnimating()
        KYCRequest.status { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess, let veriffStatus = data?.veriffStatus {
                switch veriffStatus {
                case .created, .expired, .resubmissionRequested, .abandoned:
                    this.handleVeriffAction()
                default:
                    this.submitRequest()
                }
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: UIButton) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        guard sender.alpha == 1 else { return }
        guard let country = countryTextField.text,
                let state = stateTextField.text,
                let city = cityTextField.text,
                let zipCode = postcodeTextField.text,
                let address1 = addressOneTextField.text else { return }
        requestSaveKYCStepTwo(country: country,
                              state: state,
                              city: city,
                              zipCode: zipCode,
                              address1: address1,
                              address2: addressTwoTextField.text)
    }
    
    @IBAction func countryAction(_ sender: Any) {
        inputBeginEditing(countryTextField)
        if datasource.isEmpty {
            requestRegion(isGotoAction: true, title: R.string.localizable.chooseYourContryOfResidence(), actionTextField: countryTextField)
        } else {
            gotoRegionPage(title: R.string.localizable.chooseYourContryOfResidence(), actionTextField: countryTextField, datas: datasource)
        }
    }
    
    @IBAction func stateAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        inputBeginEditing(stateTextField)
        if countryCode == nil, let country = countryTextField.text {
            RegionRequest.info(name: country) { [weak self] isSuccess, message, data in
                guard let this = self else { return }
                if isSuccess, let id = data?.id {
                    this.countryCode = id
                    this.requestRegion(id: id, isGotoAction: true, title: R.string.localizable.chooseYourStateOfResidence(), actionTextField: this.stateTextField)
                } else {
                    this.view.makeToast(message, position: .center)
                }
            }
        } else {
            guard let id = countryCode else { return }
            requestRegion(id: id, isGotoAction: true, title: R.string.localizable.chooseYourStateOfResidence(), actionTextField: stateTextField)
        }
    }
    
    @IBAction func cityAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        inputBeginEditing(cityTextField)
        if stateCode == nil, let state = stateTextField.text {
            RegionRequest.info(name: state) { [weak self] isSuccess, message, data in
                guard let this = self else { return }
                if isSuccess, let id = data?.id {
                    this.stateCode = id
                    this.requestRegion(id: id, isGotoAction: true, title: R.string.localizable.chooseYourCityOfResidence(), actionTextField: this.cityTextField)
                } else {
                    this.view.makeToast(message, position: .center)
                }
            }
        } else {
            guard let id = stateCode else { return }
            requestRegion(id: id, isGotoAction: true, title: R.string.localizable.chooseYourCityOfResidence(), actionTextField: cityTextField)
        }
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputEndEditing(textField)
    }
}

extension FillInAddressViewController: VeriffSdkDelegate {
    func sessionDidEndWithResult(_ result: Veriff.VeriffSdk.Result) {
        switch result.status {
        case .done:
            // The user successfully submitted the session
            requestSaveKYCStepThree(isVeriffPass: true)
            break
        case .canceled:
            self.dismiss(animated: true)
            // The user canceled the verification process.
            if let vcs = navigationController?.viewControllers.filter({ subVC in
                return subVC.isMember(of: UserCenterViewController.self) || subVC.isMember(of: HomeViewController.self)
            }) {
                for vc in vcs {
                    if vc.isMember(of: UserCenterViewController.self) {
                        navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                for vc in vcs {
                    if vc.isMember(of: HomeViewController.self) {
                        navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
            DLog.error("cancel!!!")
            break
        case .error(let error):
            switch error {
            case .cameraUnavailable:
                DLog.error("cameraUnavailable")
            case .microphoneUnavailable:
                DLog.error("microphoneUnavailable")
            case .serverError:
                DLog.error("serverError")
            case .localError:
                DLog.error("localError")
            case .networkError:
                DLog.error("networkError")
            case .uploadError:
                DLog.error("uploadError")
            case .videoFailed:
                DLog.error("videoFailed")
            case .deprecatedSDKVersion:
                DLog.error("deprecatedSDKVersion")
            case .unknown:
                DLog.error("unknown")
            @unknown default:
                DLog.error("default")
            }
        @unknown default:
            DLog.error("default")
        }
    }
}
