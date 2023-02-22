//
//  AuthSettingQRCodeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/21.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum AuthSettingQRCodeStatus {
    case progress
    case done
}

class AuthSettingQRCodeViewController: BaseViewController {
    
    var status: AuthSettingQRCodeStatus = .progress

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.patternAuthGuideTitle()
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var qrCodeTipsLabel: UILabel! {
        didSet {
            qrCodeTipsLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.6)
        }
    }
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        switch status {
        case .progress:
            secondLine.alpha = 1
            secondLine.backgroundColor = R.color.fw00A8BB()
            thirdLine.alpha = 0.2
            thirdLine.backgroundColor = R.color.fw76A4A7()
            numLabel.text = "2"
            subTitleLabel.text = R.string.localizable.patternAuthQrCodeSubTitle()
            // TODO: set qrcode image
            qrCodeImageView.image = nil
        case .done:
            secondLine.alpha = 0.2
            secondLine.backgroundColor = R.color.fw76A4A7()
            thirdLine.alpha = 1
            thirdLine.backgroundColor = R.color.fw00A8BB()
            numLabel.text = "3"
            subTitleLabel.text = R.string.localizable.patternAuthQrCodeDoneSubTitle()
            qrCodeImageView.image = R.image.iconQrcodeShieldSecurity()
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        switch status {
        case .progress:
            let vc = AuthSettingQRCodeViewController()
            vc.status = .done
            navigationController?.pushViewController(vc, animated: true)
        case .done:
            let vc = AuthSettingVerifyCodeViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
