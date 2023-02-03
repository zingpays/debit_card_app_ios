//
//  TransactionsFilterCollectionViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TransactionsFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.1)
    }

}
