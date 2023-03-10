//
//  FillInNameAndNationalViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/16.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class FillInNameAndNationalViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var infoLabell: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var midleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var chooseNationalTextField: UITextField!
    @IBOutlet weak var continueNextButton: UIButton!
    private var tipsCheckedDic: [Int : Bool] = [:]
    
    /// Right item
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: SCREENWIDTH-40, y: 4, width: 36, height: 36)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 12
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupNavBar()
        setupSubviews()
    }
    
    internal override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = nil
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = UIFont.fw.font16()
        infoLabell.font = .fw.font14()
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
//        phoneTextField.addTarget(self, action: #selector(phoneNumValueChangeAction), for: .editingChanged)
//        phoneTextField.becomeFirstResponder()
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
            tipsCheckedDic[0] = true
        }
        if midleNameTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[1] = true
        } else {
            tipsCheckedDic[1] = true
        }
        if lastNameTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[2] = true
        } else {
            tipsCheckedDic[2] = true
        }
        if chooseNationalTextField.text?.count ?? 0 > 0 {
            tipsCheckedDic[3] = true
        } else {
            tipsCheckedDic[3] = true
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
        continueNextButton.alpha = checkedCount == 4 ? 1 : 0.4
        return checkedCount == 4
    }
    
    // MARK: - Action
    
    @objc private func skip() {
        let expireDate: Date = Date(timeIntervalSinceNow: 60*60*24*7)
        // save user token
        UserManager.shared.saveToken("test", expireDate: expireDate)
        // change application root viewController to tabbar viewController
        UIApplication.shared.keyWindow()?.rootViewController = nil
        UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
    }
    
    @objc private func chooseNationality() {
        let vc = ChooseRegionViewController(style: .noCode)
//        let datas = [ChooseRegionModel(title: "China", subTitle: ""), ChooseRegionModel(title: "Singpore", subTitle: "")]
//        vc.pageTitle = "choose your nationality"
//        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            DispatchQueue.main.async {
                self.chooseNationalTextField.text = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func continueNext(_ sender: UIButton) {
        let vc = RegisterSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension FillInNameAndNationalViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputEndEditing(textField)
    }
}
