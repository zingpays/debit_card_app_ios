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
    var codeText: String?

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.patternAuthGuideTitle()
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var qrCodeTipsLabel: UILabel! {
        didSet {
            qrCodeTipsLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.6)
            qrCodeTipsLabel.text = R.string.localizable.authQrcodeTips()
        }
    }
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var copyCodeButton: UIButton!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    // MARK: - Private
    
    private func setupData() {
        if status == .progress {
            requestTwofaData()
        }
    }
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        refreshView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.1)
        refreshView.isHidden = true
        refreshLabel.text = R.string.localizable.refresh()
        codeLabel.text = codeText
        nextButton.setTitle(R.string.localizable.next(), for: .normal)
        switch status {
        case .progress:
            secondLine.alpha = 1
            secondLine.backgroundColor = R.color.fw00A8BB()
            thirdLine.alpha = 0.2
            thirdLine.backgroundColor = R.color.fw76A4A7()
            numLabel.text = "2"
            subTitleLabel.text = R.string.localizable.patternAuthQrCodeSubTitle()
            qrCodeImageView.image = nil
            nextButton.alpha = 0.4
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
    
    // MARK: - Network
    
    private func requestTwofaData() {
        indicator.startAnimating()
        AuthRequest.twofa { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            this.refreshView.isHidden = isSuccess
            if isSuccess {
                if let url = data?.url,
                   let dataDecoded = Data(base64Encoded: url.removingPrefix("data:image/png;base64,")),
                   let image = UIImage(data: dataDecoded) {
                    this.qrCodeImageView.image = image
                    this.nextButton.alpha = 1
                } else {
                    this.refreshView.isHidden = false
                }
                this.codeText = data?.secret
                this.codeLabel.text = data?.secret
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func refreshAction(_ sender: Any) {
        requestTwofaData()
    }
    
    @IBAction func copyAction(_ sender: Any) {
        view.makeToast(R.string.localizable.copySuccessfully(), position: .center)
        UIPasteboard.general.string = codeText
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard nextButton.alpha == 1 else { return }
        switch status {
        case .progress:
            let vc = AuthSettingQRCodeViewController()
            vc.status = .done
            vc.codeText = codeText
            navigationController?.pushViewController(vc, animated: true)
        case .done:
            let vc = AuthSettingVerifyCodeViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
