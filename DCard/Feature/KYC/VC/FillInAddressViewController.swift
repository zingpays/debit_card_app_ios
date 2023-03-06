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

    /// data source
    var datasource: [RegionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    private func gotoRegionPage() {
        let vc = ChooseRegionViewController(style: .noCode)
        vc.pageTitle = R.string.localizable.chooseYourCountryTitle()
        vc.datasource = datasource
        vc.didSelectedCompletion = { data in
            self.countryTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
        }
        self.present(vc, animated: true)
    }
    
    // MARK: - Network
    
    private func requestRegion(isGotoAction: Bool = false) {
        RegionRequest.list { isSuccess, message, list in
            if isSuccess, let regionList = list {
                self.datasource = regionList
                if isGotoAction {
                    self.gotoRegionPage()
                }
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        let vc = KYCFinishViewController()
        navigationController?.pushViewController(vc, animated: true)
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
