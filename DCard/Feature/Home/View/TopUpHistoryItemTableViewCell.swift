//
//  TopUpHistoryItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TopUpHistoryItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var statusView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    static func height() -> CGFloat {
        return 93
    }
    
    // Private
    
    private func setupUI() {
        lineView.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        statusView.backgroundColor = R.color.fw20B085()?.withAlphaComponent(0.1)
    }
    
}
