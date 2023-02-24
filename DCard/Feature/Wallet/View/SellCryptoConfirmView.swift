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
    func didSelectedContinue()
}

class SellCryptoConfirmView: UIView, NibLoadable {
    
    weak var delegate: SellCryptoConfirmViewDelegate?
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.6)
        }
    }
    @IBOutlet weak var tipsLabel: UILabel! {
        didSet {
            tipsLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.6)
        }
    }
    @IBOutlet weak var cryptoAmountTitleLabel: UILabel! {
        didSet {
            cryptoAmountTitleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!{
        didSet {
            priceTitleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topupFromTitleLabel: UILabel!{
        didSet {
            topupFromTitleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var topupFormLabel: UILabel!
    @IBOutlet weak var topupAccountTitleLabel: UILabel!{
        didSet {
            topupAccountTitleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var topupAccountLabel: UILabel!
    @IBOutlet weak var topupAmountTitleLabel: UILabel!{
        didSet {
            topupAmountTitleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var topupAmountLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueAction(_ sender: Any) {
        delegate?.didSelectedContinue()
    }
    
}
