//
//  TransactionsFilterDateCollectionViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TransactionsFilterDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.1)
        rightView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.1)
    }

}
