//
//  WalletCardTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol WalletCardTableViewCellDelegate: NSObject {
    func didSelectedDeposit(_ cell: WalletCardTableViewCell)
    func didSelectedWithdraw(_ cell: WalletCardTableViewCell)}

class WalletCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var withdrawView: UIView!
    
    weak var delegate: WalletCardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    private func setupSubviews() {
        depositView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.14)
        withdrawView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.14)
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
    }
    
    @IBAction func depositAction(_ sender: Any) {
        delegate?.didSelectedDeposit(self)
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        delegate?.didSelectedWithdraw(self)
    }
    
}
