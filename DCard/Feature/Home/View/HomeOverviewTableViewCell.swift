//
//  HomeOverviewTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/22.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum HomeOverviewTableViewCellVerifyStatus {
    case original
    case review
    case action
    case rejected
}

enum HomeOverviewTableViewCellCardStatus {
    case new
    case card
}

protocol HomeOverviewTableViewCellDelegate {
    func didSelectedVerify(_ cell: HomeOverviewTableViewCell)
    func didSelectedAddCard(_ cell: HomeOverviewTableViewCell)
    func didSelectedWallet(_ cell: HomeOverviewTableViewCell)
    func didSelectedTopup(_ cell: HomeOverviewTableViewCell)
}

class HomeOverviewTableViewCell: UITableViewCell {

    var verifyStatus: HomeOverviewTableViewCellVerifyStatus = .original
    var cardStatus: HomeOverviewTableViewCellCardStatus = .new
    var delegate: HomeOverviewTableViewCellDelegate?
    
    @IBOutlet weak var totalBlanceLabel: UILabel!
    @IBOutlet weak var verifyTipsView: UIView!
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var topupButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var debitCardLabel: UILabel!
    @IBOutlet weak var cryptoWalletLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    static func height() -> CGFloat {
        return 331
    }
    
    private func setupUI() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        topupButton.titleLabel?.font = UIFont.fw.font16(weight: .bold)
        topupButton.setTitleColorForAllStates(R.color.fw00A8BB() ?? .blue)
        topupButton.setTitle(R.string.localizable.topUpHome(), for: .normal)
        verifyTipsView.backgroundColor = R.color.fwED4949()?.withAlphaComponent(0.1)
        totalBlanceLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.6)
        totalBalanceLabel.text = R.string.localizable.totalBalance()
        debitCardLabel.text = R.string.localizable.debitCard()
        cryptoWalletLabel.text = R.string.localizable.cryptoWallet()
    }
    
    @IBAction func verifyAction(_ sender: UIButton) {
        delegate?.didSelectedVerify(self)
    }
    
    @IBAction func addCardAction(_ sender: Any) {
        delegate?.didSelectedAddCard(self)
    }
    
    @IBAction func walletAction(_ sender: Any) {
        delegate?.didSelectedWallet(self)
    }
    
    @IBAction func topupAction(_ sender: Any) {
        delegate?.didSelectedTopup(self)
    }
    
    func update() {
        
    }
}
