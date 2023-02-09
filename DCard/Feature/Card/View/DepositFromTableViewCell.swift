//
//  DepositFromTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class DepositFromTableViewCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView! {
        didSet {
            cellContentView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.1)
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var rightContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
