//
//  TransactionsFilterCollectionHeaderView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TransactionsFilterCollectionHeaderView: UICollectionReusableView {
    
    lazy var content: UILabel = {
        let l = UILabel()
        l.textColor = R.color.fwF5F5F7()
        l.font = UIFont.fw.font16()
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(content)
        content.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
