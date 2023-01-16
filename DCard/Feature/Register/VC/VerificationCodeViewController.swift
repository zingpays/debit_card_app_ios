//
//  VerificationCodeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/13.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import CRBoxInputView

class VerificationCodeViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
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
        box.loadAndPrepare(withBeginEdit: true)
        box.mainCollectionView()?.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return box
    }()
    
    @IBOutlet weak var boxInputViewContainer: UIView!
    
    private var time = DispatchSource.makeTimerSource()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
        setupSubviews()
        startCountDown()
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
    
    private func setupSubviews() {
        view.addSubview(boxInputViewContainer)
        boxInputViewContainer.addSubview(boxInputView)
        boxInputViewContainerHeightConstraint.constant = boxWidth
        boxInputView.frame = CGRect(x: 0, y: 0,
                                    width: (SCREENWIDTH - 16 - 17),
                                    height: boxWidth)
        titleLabel.font = .fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = .fw.font16()
        phoneNumLabel.font = .fw.font16()
        errorTipsLabel.font = .fw.font14()
        errorTipsLabel.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    private func updateErrorTips(isShow: Bool, text: String = "") {
        if isShow {
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
                    this.resendButton.setTitle("Resend", for: .normal)
                    this.time.cancel()
                }
            } else {
                DispatchQueue.main.async {
                    times -= 1
                    let text = "Resend after \(times)s"
                    this.resendButton.alpha = 0.4
                    this.resendButton.setTitle(text, for: .normal)
                }
            }
        })
        time.resume()
    }
    
    // MARK: - Actions
    
    @IBAction func resendAction(_ sender: UIButton) {
        // Test code
        let vc = FillInNameAndNationalViewController()
        navigationController?.pushViewController(vc, animated: true)
//        if sender.alpha == 1 {
//            // TODO: 请求网络校验验证码是否正确
//            boxInputView.clearAll(withBeginEdit: true)
//            resendButton.alpha = 0.4
//        }
    }

}
