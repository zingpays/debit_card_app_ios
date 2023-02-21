//
//  SecurityCollectionViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/20.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

struct SecurityCollectionViewCellModel {
    var icon: UIImage?
    var title: String?
    var status: Bool
}

class SecurityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(data: SecurityCollectionViewCellModel) {
        iconImageView.image = data.icon
        titleLabel.text = data.title
        if data.status {
            statusImageView.image = R.image.iconTick()
        } else {
            statusImageView.image = R.image.iconInfoRed()
        }
    }
}
