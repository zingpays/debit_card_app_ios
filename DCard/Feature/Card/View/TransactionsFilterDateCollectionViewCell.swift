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
    
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    
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
    
    func update(data: FilterDateModel) {
        if let from = data.from {
            dateFromLabel.text = from.iso8601String
        } else {
            dateFromLabel.text = R.string.localizable.select()
        }
        if let to = data.to {
            dateToLabel.text = to.iso8601String
        } else {
            dateToLabel.text = R.string.localizable.select()
        }
    }
}
