//
//  TransactionItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import SwiftDate

enum TransactionItemTableViewCellStyle {
    case content
    case withFlag
}

class TransactionItemTableViewCell: UITableViewCell {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var leftStackView: UIStackView!
    private lazy var leftTitleLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.fw000000()
        l.font = UIFont.fw.font16()
        l.text = "--"
        return l
    }()
    private lazy var leftIconView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = R.image.iconFrom()
        return imageV
    }()
    private lazy var leftSubTitleLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.fw000000()?.withAlphaComponent(0.5)
        l.font = UIFont.fw.font12(weight: .light)
        l.text = "--"
        return l
    }()
    private lazy var leftSubTitleView: UIView = {
        let v = UIView()
        return v
    }()
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSubviews() {
        leftStackView.addArrangedSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        leftStackView.addArrangedSubview(leftSubTitleView)
        leftSubTitleView.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
        leftSubTitleView.addSubview(leftIconView)
        leftIconView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(14)
        }
        leftSubTitleView.addSubview(leftSubTitleLabel)
        leftSubTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIconView.snp.right).offset(4)
            make.top.bottom.right.equalToSuperview()
        }
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }
    
    func update(style: TransactionItemTableViewCellStyle, data: TransactionItemModel) {
        leftTitleLabel.text = data.type.formatName()
        if let amount = data.amount {
            amountLabel.text = data.type == .consume ? "-$\(amount)" : "+$\(amount)"
        }
        dateLabel.text = data.updatedAt
        if style == .content {
            leftSubTitleView.removeFromSuperview()
        } else {
            leftStackView.addArrangedSubview(leftSubTitleView)
            leftSubTitleView.snp.makeConstraints { make in
                make.height.equalTo(14)
            }
            leftSubTitleLabel.text = data.merchant?.name
        }
    }
}
