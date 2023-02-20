//
//  LanguageTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/17.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class LanguageModel: NSObject {
    var title: String
    var isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateData(data: LanguageModel) {
        if data.isSelected {
            titleLabel.textColor = R.color.fw00A8BB()
            titleLabel.text = data.title
            checkImageView.isHidden = false
        } else {
            titleLabel.textColor = R.color.fw001214()
            titleLabel.text = data.title
            checkImageView.isHidden = true
        }
    }
    
}
