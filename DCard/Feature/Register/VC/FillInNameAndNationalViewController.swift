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
    
    // MARK: - Private
    
    private func setupUI() {
        setupNavBar()
        setupGradientBackground()
        setupSubviews()
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 0.1
        view.layer.insertSublayer(bgLayer, at: 0)
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
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 50)))
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
        // TODO: - go to home page
    }
    
    @objc private func chooseNationality() {
        
    }
    
    @IBAction func continueNext(_ sender: UIButton) {
        
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
