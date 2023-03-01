//
//  WithdrawViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class WithdrawViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterLineView: UIView!
    @IBOutlet weak var inputLineView: UIView!
    @IBOutlet weak var cryptoInputView: UIView!
    @IBOutlet weak var inputContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        filterLineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        inputLineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }
    
    private func inputBeginEditing() {
        inputContentView.layer.borderColor = R.color.fw00A8BB()?.cgColor
        inputContentView.layer.borderWidth = 2
        inputLineView.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.3)
    }
    
    private func inputViewEndEditing() {
        inputContentView.layer.borderWidth = 0
        inputLineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }

    // MARK: - Actions
    
    @IBAction func withdrawNetworkInfoAction(_ sender: Any) {
        let alert = UIAlertController(title: "What is network ?", message: "Network is the path for crypto transfer between wallets and most cryptos have more than one network selections.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got It", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func filterCryptoAction(_ sender: Any) {
        popup.bottomSheet {
            let v = ChooseCryptoNetworkView.loadFromNib()
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 230+80*4 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 230+80*4 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        guard let email = UserManager.shared.email else { return }
        let vc = SecurityVerificationViewController(email: email, phone: UserManager.shared.phoneNum)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WithdrawViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputViewEndEditing()
    }
}

extension WithdrawViewController: ChooseCryptoNetworkViewDelegate {
    func didSelectedNetworkItem(_ view: ChooseCryptoNetworkView) {
        popup.dismissPopup()
        
    }
}
