//
//  AuthSettingVerifyCodeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/21.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import CRBoxInputView

class AuthSettingVerifyCodeViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.patternAuthGuideTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.patternAuthCodeSubTitle();
        }
    }
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var boxInputViewContainer: UIView!
    @IBOutlet weak var tipsLabel: UILabel! {
        didSet {
            tipsLabel.text = R.string.localizable.patternAuthCodeTips()
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.submit(), for: .normal)
        }
    }
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
    @IBOutlet weak var boxInputViewContainerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        view.addSubview(boxInputViewContainer)
        boxInputViewContainer.addSubview(boxInputView)
        boxInputViewContainerHeightConstraint.constant = boxWidth
        boxInputView.frame = CGRect(x: 0, y: 0,
                                    width: (SCREENWIDTH - 16 - 17),
                                    height: boxWidth)
    }

    @IBAction func submitAction(_ sender: Any) {
        let vc = AuthSettingSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
