//
//  WalletCryptoItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class WalletCryptoItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }
    
}
