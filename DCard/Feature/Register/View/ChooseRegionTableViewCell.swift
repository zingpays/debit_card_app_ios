//
//  ChooseRegionTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/12.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ChooseRegionTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
    
    }
}
