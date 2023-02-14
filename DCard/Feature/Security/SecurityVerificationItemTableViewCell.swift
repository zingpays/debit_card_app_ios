//
//  SecurityVerificationItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/14.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SecurityVerificationItemTableViewCellStyle {
    case normal
    case auth
}

protocol SecurityVerificationItemTableViewCellDelegate: NSObject {
    func didSelectedAuthUnavailable()
}

class SecurityVerificationItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var authUnavaiableButton: UIButton! {
        didSet {
            authUnavaiableButton.setTitle(R.string.localizable.googleAuthenticatorUnavailable(), for: .normal)
        }
    }
    @IBOutlet weak var authUnavaiableButtonHeight: NSLayoutConstraint!
    
    weak var delegate: SecurityVerificationItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        inputTextField.leftViewMode = .always
        inputTextField.leftView = textFiledLeftView()
        inputTextField.rightViewMode = .always
        inputTextField.rightView = textFieldRightView(#selector(inputAction))
    }
    
    private func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero,
                                    size: CGSize(width: 16, height: 50)))
    }
    
    private func textFieldRightView(_ action: Selector) -> UIView {
        let size = CGSize(width: 100, height: 50)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        let btn = UIButton()
        btn.setTitle(R.string.localizable.getCode(), for: .normal)
        btn.titleLabel?.font = .fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 11), size: CGSize(width: 100, height: 28))
        btn.contentMode = .right
        v.addSubview(btn)
        return v
    }
    
    // MARK: - Actions
    @objc private func inputAction() {
        
    }
    
    
    @IBAction func authUnavailableAction(_ sender: Any) {
        delegate?.didSelectedAuthUnavailable()
    }
    
    static func height(style: SecurityVerificationItemTableViewCellStyle) -> CGFloat {
        switch style {
        case .normal:
            return 160
        case .auth:
            return 180
        }
    }
    
    func upadateData(data: SecurityVerificationItemModel) {
        switch data.style {
        case .normal:
            authUnavaiableButtonHeight.constant = 0
            authUnavaiableButton.isHidden = true
            inputTextField.rightViewMode = .always
        case .auth:
            authUnavaiableButtonHeight.constant = 19
            authUnavaiableButton.isHidden = false
            inputTextField.rightViewMode = .never
        }
        titleLabel.text = data.title
        infoLabel.text = data.info
        inputTextField.placeholder = data.inputPlaceholder
    }
}
