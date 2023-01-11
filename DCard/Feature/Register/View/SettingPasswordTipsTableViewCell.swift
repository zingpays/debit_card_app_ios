//
//  SettingPasswordTipsTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/11.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SettingPasswordTipsTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        descLabel.font = .fw.font14()
        descLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func updateStatus(isChecked: Bool) {
        if isChecked {
            statusImageView.image = R.image.iconTickOn()
            descLabel.textColor = R.color.fw000000()
        } else {
            statusImageView.image = R.image.iconTickOff()
            descLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        }
    }
    
}
