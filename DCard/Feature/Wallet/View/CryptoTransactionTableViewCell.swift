//
//  CryptoTransactionTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CryptoTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var flagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        flagLabel.backgroundColor = R.color.fw00DF9C()?.withAlphaComponent(0.1)
    }
}
