//
//  SecurityVerificationItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/14.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SecurityVerificationItemTableViewCellStyle {
    case email
    case phone
    case auth
    case authWithoutReset
}

protocol SecurityVerificationItemTableViewCellDelegate: NSObject {
    func didSelectedAuthUnavailable(_ cell: SecurityVerificationItemTableViewCell)
    func didSelectedSendCode(_ cell: SecurityVerificationItemTableViewCell,
                             data: SecurityVerificationItemModel)
    func inputTextFieldEditing(_ cell: SecurityVerificationItemTableViewCell,
                               _ text: String?,
                               data: SecurityVerificationItemModel?)
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
    @IBOutlet weak var infoLabelHeight: NSLayoutConstraint!
    
    weak var delegate: SecurityVerificationItemTableViewCellDelegate?
    
    private var itemModel: SecurityVerificationItemModel?
    private lazy var getCodeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(R.string.localizable.getCode(), for: .normal)
        btn.titleLabel?.font = .fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 11), size: CGSize(width: 140, height: 28))
        btn.contentMode = .right
        return btn
    }()
    private var isCountDowning: Bool = false
    private var isCountDowned: Bool = false
    
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
        let size = CGSize(width: 140, height: 50)
        let v = UIView(frame: CGRect(origin: .zero, size: size))
        v.backgroundColor = .clear
        getCodeButton.addTarget(self, action: action, for: .touchUpInside)
        v.addSubview(getCodeButton)
        return v
    }
    
    private func startCountDown() {
        let time = DispatchSource.makeTimerSource()
        isCountDowning = true
        var times = 60
        time.schedule(deadline: .now(), repeating: 1)
        time.setEventHandler { [weak self] in
            guard let this = self else { return }
            if times <= 0 {
                DispatchQueue.main.async {
                    this.getCodeButton.setTitle(R.string.localizable.resend(), for: .normal)
                    time.suspend()
                    this.isCountDowning = false
                    this.itemModel?.getCodeButtonStatus = .resend
                }
            } else {
                DispatchQueue.main.async {
                    times -= 1
                    let text = LocalizationManager.shared.currentLanguage() == .zh ? "\(times)s后重新发送" : "Resend after \(times)s"
                    this.getCodeButton.setTitle(text, for: .normal)
                }
            }
        }
        time.resume()
    }
    
    // MARK: - Actions
    @objc private func inputAction() {
        guard let data = itemModel else { return }
        delegate?.didSelectedSendCode(self, data: data)
    }
    
    @IBAction func inputEditingChangedAction(_ sender: UITextField) {
        itemModel?.text = sender.text ?? ""
        delegate?.inputTextFieldEditing(self, sender.text, data: itemModel)
    }
    
    @IBAction func authUnavailableAction(_ sender: Any) {
        delegate?.didSelectedAuthUnavailable(self)
    }
    
    static func height(style: SecurityVerificationItemTableViewCellStyle, infoStyle: SecurityVerificationItemInfoStyle) -> CGFloat {
        var height: CGFloat = 0
        switch style {
        case .email, .phone, .authWithoutReset:
            height = 140
            switch infoStyle {
            case .none:
                height = 115
            case .tips, .error:
                break
            }
        case .auth:
            height = 170
            switch infoStyle {
            case .none:
                height = 142
            case .tips, .error:
                break
            }
        }
        return height
    }
    
    func upadateData(data: SecurityVerificationItemModel) {
        itemModel = data
        switch data.style {
        case .email, .phone:
            authUnavaiableButtonHeight.constant = 0
            authUnavaiableButton.isHidden = true
            inputTextField.rightViewMode = .always
        case .authWithoutReset:
            authUnavaiableButtonHeight.constant = 0
            authUnavaiableButton.isHidden = true
            inputTextField.rightViewMode = .never
        case .auth:
            authUnavaiableButtonHeight.constant = 19
            authUnavaiableButton.isHidden = false
            inputTextField.rightViewMode = .never
        }
        titleLabel.text = data.title
        infoLabel.text = data.info
        inputTextField.placeholder = data.inputPlaceholder
        inputTextField.text = data.text
        switch data.infoStyle {
        case .none:
            infoLabel.isHidden = true
            infoLabelHeight.constant = 0
        case .tips:
            infoLabel.isHidden = false
            infoLabel.textColor = R.color.fw001214()
            infoLabel.font = UIFont.fw.font14(weight: .light)
            infoLabelHeight.constant = 18
        case .error:
            infoLabel.isHidden = false
            infoLabel.textColor = R.color.fwED4949()
            infoLabel.font = UIFont.fw.font14(weight: .regular)
            infoLabelHeight.constant = 18
        }
        switch data.getCodeButtonStatus {
        case .normal:
            getCodeButton.setTitle(R.string.localizable.getCode(), for: .normal)
        case .resend:
            getCodeButton.setTitle(R.string.localizable.resend(), for: .normal)
        case .countDown:
            if isCountDowning {
                break
            } else {
                startCountDown()
            }
        }
    }
}
