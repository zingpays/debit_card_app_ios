//
//  DepositViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class DepositViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLine: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var QRCodeHLineView: UIView!
    @IBOutlet weak var QRCodeVLineView: UIView!
    @IBOutlet weak var tipsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
            make.height.equalTo(33)
        }
        filterLine.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        QRCodeHLineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        QRCodeVLineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        addressView.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
    }
    
    // MARK: - Actions
    
    @IBAction func saveQRCodeAction(_ sender: Any) {
        
    }
    
    @IBAction func copyAddressAction(_ sender: Any) {
        
    }
    
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
    
}

extension DepositViewController: ChooseCryptoNetworkViewDelegate {
    func didSelectedNetworkItem(_ view: ChooseCryptoNetworkView) {
        popup.dismissPopup()
        
    }
}
