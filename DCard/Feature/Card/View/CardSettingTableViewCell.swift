//
//  CardSettingTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum CardSettingTableViewCellType {
    case arrow
    case content
}

class CardSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(type: CardSettingTableViewCellType = .arrow) {
        if type == .arrow {
            arrowImageView.isHidden = false
            statusTextLabel.isHidden = false
            percentageLabel.isHidden = true
        }
        if type == .content {
            arrowImageView.isHidden = true
            statusTextLabel.isHidden = true
            percentageLabel.isHidden = false
        }
    }
}
