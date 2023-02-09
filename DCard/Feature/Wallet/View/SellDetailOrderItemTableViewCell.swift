//
//  SellDetailOrderItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SellDetailOrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .red
        titleLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        contentLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.87)
    }
}
