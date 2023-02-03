//
//  TransactionsFilterDateCollectionViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol TransactionsFilterDateCollectionViewCellDelegate: NSObject {
    func didSelectedStartDate()
    func didSelectedEndDate()
}

class TransactionsFilterDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    weak var delegate: TransactionsFilterDateCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.1)
        rightView.backgroundColor = R.color.fwFFFFFF()?.withAlphaComponent(0.1)
    }

    // MARK: - Actions
    
    @IBAction func startDateAction(_ sender: Any) {
        delegate?.didSelectedStartDate()
    }
    
    @IBAction func endDateAction(_ sender: Any) {
        delegate?.didSelectedEndDate()
    }
    
}
