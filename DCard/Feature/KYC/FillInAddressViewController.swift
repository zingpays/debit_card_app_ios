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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = UIFont.fw.font16()
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
    }
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 50)))
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

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        
    }
    
    @IBAction func countryAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        let vc = ChooseRegionViewController()
        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
        vc.pageTitle = "choose your country"
        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.countryTextField.text = data.title
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func stateAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        let vc = ChooseRegionViewController()
        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
        vc.pageTitle = "choose your country"
        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.stateTextField.text = data.title
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func cityAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.endEditing(true)
        let vc = ChooseRegionViewController()
        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
        vc.pageTitle = "choose your country"
        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.cityTextField.text = data.title
            }
        }
        self.present(vc, animated: true)
    }
}
