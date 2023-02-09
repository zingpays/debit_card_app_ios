//
//  SellCryptoViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/7.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

class SellCryptoViewController: BaseViewController {
    
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.layer.cornerRadius = 18
        btn.setImage(R.image.iconRecordBtn(), for: .normal)
        btn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var inputContentView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        statusLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        inputTextField.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        priceLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        priceTagLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    private func inputBeginEditing() {
        inputContentView.layer.borderColor = R.color.fw00A8BB()?.cgColor
        inputContentView.layer.borderWidth = 2
        line.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.3)
    }
    
    private func inputViewEndEditing() {
        inputContentView.layer.borderWidth = 0
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }

    // MARK: - Actions
    
    @IBAction func filterAction(_ sender: Any) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    @objc private func recordAction() {
        
    }
    
    
    @IBAction func sellCryptoAction(_ sender: Any) {
        popup.dialog {
            let v = SellCryptoConfirmView.loadFromNib()
            v.frame = CGRect(origin: CGPoint(x: 26, y: 0), size: CGSize(width: SCREENWIDTH-52, height: 314))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH-52, height: 314))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
}

extension SellCryptoViewController: DepositFromViewDelegate {
    func didSelectedRecord(_ view: DepositFromView) {}
    
    func didSelectedDepositItem(_ view: DepositFromView) {
        popup.dismissPopup()
    }
}

extension SellCryptoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputViewEndEditing()
    }
}

extension SellCryptoViewController: SellCryptoConfirmViewDelegate {
    func didSelectedCancel() {
        popup.dismissPopup()
    }
    
    func didSelectedContinue() {
        popup.dismissPopup()
    }
    
}
