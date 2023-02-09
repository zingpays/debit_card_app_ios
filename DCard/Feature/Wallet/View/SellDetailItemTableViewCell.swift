//
//  SellDetailItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/8.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SellDetailItemTableViewCellStatus {
    case doing
    case waiting
    case done
}

enum SellDetailItemTableViewCellType {
    case contentWithIcon
    case content
    case contentWithDesc
}

class SellDetailItemTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagContentLabel: UILabel!
    @IBOutlet weak var tagIconImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cryptoImageView: UIImageView!
    @IBOutlet weak var cryptoCount: UILabel!
    /// BTC/ETH...
    @IBOutlet weak var cryptoType: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func iconWithStatus(_ status: SellDetailItemTableViewCellStatus) -> UIImage? {
        switch status {
        case .doing:
            return R.image.iconStepDoing()
        case .done:
            return R.image.iconStepDone()
        case .waiting:
            return R.image.iconStepWait()
        }
    }
    
    private func colorWithStatus(_ status: SellDetailItemTableViewCellStatus) -> UIColor? {
        if status == .waiting {
            return R.color.fw000000()?.withAlphaComponent(0.4)
        } else {
            return R.color.fw000000()?.withAlphaComponent(0.87)
        }
    }
    
    private func updateTag(_ type: SellDetailItemTableViewCellType) {
        switch type {
        case .contentWithIcon:
            tagView.isHidden = true
        case .content:
            tagView.isHidden = true
        case .contentWithDesc:
            tagView.isHidden = false
        }
    }
    
    func updateData(type: SellDetailItemTableViewCellType = .content, status: SellDetailItemTableViewCellStatus, isLastItem: Bool = false) {
        statusImageView.image = iconWithStatus(status)
        cryptoCount.textColor = colorWithStatus(status)
        statusTitleLabel.textColor = colorWithStatus(status)
        updateTag(type)
        lineView.isHidden = isLastItem
        switch type {
        case .contentWithIcon:
            cryptoImageView.snp.remakeConstraints { make in
                make.width.equalTo(28)
            }
            cryptoType.snp.remakeConstraints { make in
                make.width.equalTo(30)
            }
            descLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
            tagView.isHidden = true
        case .content:
            cryptoImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            cryptoType.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            descLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        case .contentWithDesc:
            cryptoImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            cryptoType.snp.remakeConstraints { make in
                make.width.equalTo(0)
            }
            descLabel.snp.remakeConstraints { make in
                make.height.equalTo(40)
            }
            tagView.isHidden = false
        }
    }
}
