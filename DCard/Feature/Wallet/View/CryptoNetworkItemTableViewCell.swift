//
//  CryptoNetworkItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CryptoNetworkItemTableViewCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        cellContentView.backgroundColor = R.color.fw76A4A7()?.withAlphaComponent(0.1)
    }
}
