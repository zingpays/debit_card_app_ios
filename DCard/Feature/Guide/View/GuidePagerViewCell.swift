//
//  GuidePagerViewCell.swift
//  Flashwire
//
//  Created by Fei Zhang on 2023/1/5.
//  Copyright © 2023 Zing Tech. All rights reserved.
//

import FSPagerView

class GuidePagerViewCell: FSPagerViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var guideImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        titleLabel.font = UIFont.fw.font32(type: .roboto, weight: .bold)
        descLabel.font = .fw.font14(type: .roboto, weight: .light)
    }
}
