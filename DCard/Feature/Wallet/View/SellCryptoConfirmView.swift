//
//  SellCryptoConfirmView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/7.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

protocol SellCryptoConfirmViewDelegate: NSObject {
    func didSelectedCancel()
    func didSelectedContinue()
}

class SellCryptoConfirmView: UIView, NibLoadable {
    
    weak var delegate: SellCryptoConfirmViewDelegate?

    @IBOutlet weak var cancelBtn: UIButton! {
        didSet {
            cancelBtn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
            cancelBtn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.didSelectedCancel()
    }
    
}
