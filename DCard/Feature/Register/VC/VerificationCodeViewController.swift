//
//  VerificationCodeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import CRBoxInputView
import SwiftDate

class VerificationCodeViewController: BaseViewController {
    ///  phone number
    var phoneNum: String?
    var phoneCountryCode: String?
    var uniqueId: String?
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.toVerifyPhoneNumberTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.phoneCodeInputSubTitle()
        }
    }
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var errorTipsLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var boxInputViewContainerHeightConstraint: NSLayoutConstraint!
    
    private let boxWidth = (SCREENWIDTH - 16 - 17 - 12 * 5) / 6.0
     
    private let cellProperty: CRBoxInputCellProperty = {
        let property = CRBoxInputCellProperty()
        property.cellBgColorNormal = R.color.fwFFFFFF() ?? .white
        property.cellBgColorSelected = R.color.fwFFFFFF() ?? .white
        property.cellCursorColor = .clear
        property.cellCursorHeight = 30
        property.cornerRadius = 4
        property.borderWidth = 2
        property.cellBorderColorSelected = R.color.fw00A8BB() ?? .white
        property.cellBorderColorNormal = .clear
        property.cellFont = UIFont.fw.font28(weight: .medium)
        property.cellTextColor = R.color.fw000000() ?? .white
        property.configCellShadowBlock = { layer in
            layer.shadowColor = R.color.fw005960()?.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
        }
        return property
    }()
    
    private lazy var boxInputView: CRBoxInputView = {
        let box = CRBoxInputView(codeLength: 6)!
        box.inputType = .number
        box.boxFlowLayout?.itemSize = CGSize(width: boxWidth-10, height: boxWidth-10)
        box.customCellProperty = self.cellProperty
        box.loadAndPrepare(withBeginEdit: false)
        box.mainCollectionView()?.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return box
    }()
    
    @IBOutlet weak var boxInputViewContainer: UIView!
    
    private var time = DispatchSource.makeTimerSource()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupSubviews()
    }
    
    private func setupData() {
        startCountDown()
        boxAction()
        phoneNumLabel.text = phoneNum
    }
    
    private func setupSubviews() {
        view.addSubview(boxInputViewContainer)
        boxInputViewContainer.addSubview(boxInputView)
        boxInputViewContainerHeightConstraint.constant = boxWidth
        boxInputView.frame = CGRect(x: 0, y: 0,
                                    width: (SCREENWIDTH - 16 - 17),
                                    height: boxWidth)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        errorTipsLabel.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    private func updateErrorTips(isShow: Bool, text: String = "") {
        if isShow {
            errorTipsLabel.text = text
            errorTipsLabel.snp.remakeConstraints { make in
                make.height.equalTo(16)
            }
        } else {
            errorTipsLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    private func startCountDown() {
        var times = 60
        time.schedule(deadline: .now(), repeating: 1)
        time.setEventHandler(handler: { [weak self] in
            guard let this = self else { return }
            if times < 0 {
                DispatchQueue.main.async {
                    this.resendButton.alpha = 1
                    this.resendButton.setTitle(R.string.localizable.resend(), for: .normal)
                    this.time.cancel()
                }
            } else {
                DispatchQueue.main.async {
                    times -= 1
                    let text = LocalizationManager.shared.currentLanguage() == .zh ? "\(times)s后重新发送" : "Resend after \(times)s"
                    this.resendButton.alpha = 0.4
                    this.resendButton.setTitle(text, for: .normal)
                }
            }
        })
        time.resume()
    }
    
    // MARK: - Network
    
    private func requestVerifyPhoneCode(_ code: String, uniId: String, num: String, phoneCountryCode: String) {
        indicator.startAnimating()
        PhoneRequest.setPhone(code: code, uniId: uniId, number: num, phoneCountryCode: phoneCountryCode) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                if let email = data?.user?.email,
                   let phoneNum = data?.user?.phoneNumber,
                    let expireDate = data?.accessTokenExpireDate,
                    let token = data?.accessToken {
                    if let date = expireDate.toDate()?.date {
                        UserManager.shared.saveToken(token, expireDate: date)
                        UserManager.shared.saveUserEmail(email)
                        UserManager.shared.saveUserPhoneNum(phoneNum)
                        LocalAuthenManager.shared.isAuthorized = true
                        // change application root viewController to tabbar viewController
                        UIApplication.shared.keyWindow()?.rootViewController = nil
                        UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
                    } else {
                        this.updateErrorTips(isShow: true, text: "date parse error")
                    }
                } else {
                    
                }
            } else {
                this.updateErrorTips(isShow: true, text: message)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func resendAction(_ sender: UIButton) {
        indicator.startAnimating()
        PhoneRequest.sendCode(number: phoneNum ?? "") { [weak self] isSuccess, message in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.boxInputView.clearAll(withBeginEdit: true)
            } else {
                this.view.makeToast(message)
            }
        }
    }

    private func boxAction() {
        boxInputView.textDidChangeblock = { [weak self] text, isFinish in
            guard let this = self else { return }
            if isFinish {
                this.requestVerifyPhoneCode(text ?? "", uniId: this.uniqueId ?? "", num: this.phoneNum ?? "", phoneCountryCode: "")
            }
        }
    }
    
}
